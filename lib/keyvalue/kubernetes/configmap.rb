require 'json'
require 'keyvalue/kubernetes/configmap/version'
require 'keyvalue/kubernetes/configmap/kubernetes_client_factory'

module KeyValue
  module Kubernetes
    module Configmap
      class KeyNotFoundError < StandardError; end

      class Client
        include KubernetesClientFactory

        def initialize(kubernetes_client = nil)
          @k8s_client = kubernetes_client || create_client
        end

        def read_key(key_name)
          configmap = @k8s_client.get_config_map(key_name, 'default')
          JSON.parse(configmap.data.value)
        rescue Kubeclient::ResourceNotFoundError
          raise KeyNotFoundError, "Key '#{key_name}' not found"
        end

        def update_key(key_name, value)
          @k8s_client.patch_config_map(
            key_name,
            { data: { value: value.to_json } },
            'default'
          )
        rescue Kubeclient::ResourceNotFoundError
          raise KeyNotFoundError, "Key '#{key_name}' not found"
        end
      end
    end
  end
end
