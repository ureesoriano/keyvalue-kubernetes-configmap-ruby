require 'keyvalue-kubernetes-configmap'

client = KeyValue::Kubernetes::Configmap::Client.new
key = 'keyvalue-k8s-example-configmap'  # name of the example configmap

value = client.read_key(key)
pp value  # original value

updated_value = {'answer' => '42'}
client.update_key(key, updated_value)

value = client.read_key(key)
pp value  # updated value
