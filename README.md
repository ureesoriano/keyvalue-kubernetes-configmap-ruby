# Keyvalue::Kubernetes::Configmap

Key-value store backed by kubernetes configmaps.  
It exposes a create, read, update & delete API that transparently stores values in configmaps (IE: etcd).

Designed for in-cluster use; but it also supports authenticating from outside of a Kubernetes cluster.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keyvalue-kubernetes-configmap'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install keyvalue-kubernetes-configmap



## Usage

```ruby
client = KeyValue::Kubernetes::Configmap::Client.new
key_name = 'my_configmap_name'

value = client.read_key(key_name)

updated_value = {'answer' => 42}
client.update_key(key_name, updated_value)
```



## Methods
##### Constructor
Returns a new instance of `KeyValue::Kubernetes::Configmap::Client`.
Supports injecting an already instantiated kubernetes client.
```ruby
client = KeyValue::Kubernetes::Configmap::Client.new

# Injecting a kubernetes client
require 'kubeclient'
kubeclient = Kubeclient::Client.new(...)
client = KeyValue::Kubernetes::Configmap::Client.new(kubeclient)
```

##### read_key
Reads the and returns the content of the specified configmap.
```ruby
value = client.read_key(configmapName)
```

##### update_key
Updates the content of the specified configmap with the specified value.
```ruby
client.update_key(key, {'message' => 'all your base are belong to us!'})
```



## Authentication
In order to authenticate against the Kubernetes API of your cluster, 3 authentication methods are supported:  
**1.** Via `KUBECONFIG` environment var.  
**2.** In-cluster.  
**3.** By injecting an already instantiated kubernetes client through the constructor.  

**1.** Following convention, **if the environment variable `KUBECONFIG` is set** and it contains the path to a kubeconfig file, `keyvalue-kubernetes-configmap` will read its content and attempt to authenticate against the cluster with it.

**2.** When running **inside of a cluster**, `keyvalue-kubernetes-configmap` will authenticate as the service account that your application runs as in the cluster.  
Take into account that if you did not specify a service account on your container spec, your application is very likely running as the `default` service account; and [by default] the `default` service account cannot manage configmaps.
The recommended approach here is provisioning a service account and set it as the service account in your application containers spec. No worries, a full setup of service account + role + role binding + container spec is provided in the [examples section](#Examples) `:)`

**3.** Lastly, an already instantiated **kubernetes client can be injected** through the constructor:
```ruby
require 'kubeclient'
kubeclient = Kubeclient::Client.new(...)
client = KeyValue::Kubernetes::Configmap::Client.new(kubeclient)
```



## Setup
The recommended setup is:
* Create a service account for your application.
* Create a role that allows managing configmaps.
* Attach the role to the service account via a role binding.
* Have your application run as the created service account in your cluster.

A fully working example of these resources can be found in the infra folder of the [examples](https://github.com/ureesoriano/keyvalue-kubernetes-configmap-ruby/tree/master/examples/infra).



## Examples
A fully working example can be found in the [examples folder](https://github.com/ureesoriano/keyvalue-kubernetes-configmap-ruby/tree/master/examples).

```bash
# clone the repo
git clone git@github.com:ureesoriano/keyvalue-kubernetes-configmap-ruby.git
cd keyvalue-kubernetes-configmap-ruby

# deploy the serviceaccount + role + role binding in your cluster
cd examples/
kubectl apply -f infra/rbac.yaml

# deploy the example configmap in your cluster
kubectl apply -f infra/configmap.yaml

# to test the functionality outside of a kubernetes cluster (IE: locally), set up
# the KUBECONFIG environment variable to the path of a kubeconfig file that
# authenticates in the cluster *as the service account*
export KUBECONFIG=~/.kube/service_account_config

# run the example
bundle exec ruby example.js

# to test the provided funcionality inside of a kubernetes cluster, assign the
# service account to a deployment/cronjob/job... as in the provided job example
```


## Current Limitations
At this point, be aware of the following relevant limitations:
* createKey and deletekey methods are not yet implemented.
* Only namespace `default` is supported.
* It is not possible yet to specify a kubernetes API version.

These are, in order, the next features on the roadmap (PRs are welcome `:D`).



## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
