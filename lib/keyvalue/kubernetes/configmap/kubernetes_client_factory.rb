require 'kubeclient'

module KeyValue
  module Kubernetes
    module Configmap
      module KubernetesClientFactory

        def create_client(path_to_kubeconfig_file = nil)
          config = Kubeclient::Config.read(path_to_kubeconfig_file || ENV['KUBECONFIG'])

          Kubeclient::Client.new(
            config.context.api_endpoint,
            'v1',
            ssl_options: config.context.ssl_options,
            auth_options: config.context.auth_options,
          )
        end
      end
    end
  end
end
