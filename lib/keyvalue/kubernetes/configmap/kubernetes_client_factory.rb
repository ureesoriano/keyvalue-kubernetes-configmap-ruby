require 'kubeclient'

module KeyValue
  module Kubernetes
    module Configmap
      module KubernetesClientFactory

        def create_client(path_to_kubeconfig_file = nil)
          if path_to_kubeconfig_file or ENV['KUBECONFIG']
            config = Kubeclient::Config.read(path_to_kubeconfig_file || ENV['KUBECONFIG'])

            Kubeclient::Client.new(
              config.context.api_endpoint,
              'v1',
              ssl_options: config.context.ssl_options,
              auth_options: config.context.auth_options,
            )
          else
            # in-cluster authentication
            auth_options = {
              bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token'
            }
            ssl_options = {}
            if File.exist?("/var/run/secrets/kubernetes.io/serviceaccount/ca.crt")
              ssl_options[:ca_file] = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
            end

            Kubeclient::Client.new(
              'https://kubernetes.default.svc',
              'v1',
              auth_options: auth_options,
              ssl_options:  ssl_options
            )
          end

        end
      end
    end
  end
end
