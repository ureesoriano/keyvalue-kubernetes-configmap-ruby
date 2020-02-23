require 'uuid'
require 'json'
include KeyValue::Kubernetes::Configmap::KubernetesClientFactory

RSpec.describe KeyValue::Kubernetes::Configmap::Client do
  keyvalueK8s = KeyValue::Kubernetes::Configmap::Client.new
  k8s_client = KeyValue::Kubernetes::Configmap::KubernetesClientFactory.create_client
  uuid = UUID.new

  describe "Read key" do

    context "Existing key" do
      key_name = "test-configmap-#{uuid.generate}"
      value = ''

      it "returns the configmap content" do
        Given "a configmap named #{key_name}" do
          k8s_client.create_config_map({
            :metadata => { :name => key_name, :namespace => 'default' },
            :data => { :value => { 'message' => 'All your base are belong to us!' }.to_json },
          })
        end

        When "reading the value of the key #{key_name}" do
          value = keyvalueK8s.read_key(key_name)
        end

        Then "the value contains the data in the configmap" do
          expect(value).to eq({'message' => 'All your base are belong to us!'})
        end
      end

      after(:example) do
        k8s_client.delete_config_map(key_name, 'default')
      end
    end

    context "Non-existent key" do
      it "raises an exception" do
        non_existant_key = "non-existant-configmap-#{uuid.generate}"

        Given "a non-existant configmap '#{non_existant_key}'" do
        end

        When "attempting to read the value of the key '#{non_existant_key}'" do
        end

        Then "a 'not found' exception is raised" do
          expect { keyvalueK8s.read_key(non_existant_key) }.to raise_exception(Exception, /not found/)
        end
      end
    end
  end

  describe "Update key" do
    context "Existing key" do
      key_name = "test-configmap-#{uuid.generate}"
      value = ''

      it "updates the configmap content" do
        Given "a configmap named #{key_name}" do
          k8s_client.create_config_map({
            :metadata => { :name => key_name, :namespace => 'default' },
            :data => { :value => { 'message' => 'All your base are belong to us!' }.to_json },
          })
        end

        When "updating the value of the key #{key_name}" do
          keyvalueK8s.update_key(key_name, {'answer' => '42'})
        end

        Then "the data in the configmap contains updated value" do
          updatedConfigmap = k8s_client.get_config_map(key_name, 'default')
          expect(JSON.parse(updatedConfigmap.data.value)).to eq({'answer' => '42'})
        end
      end

      after(:example) do
        k8s_client.delete_config_map(key_name, 'default')
      end
    end

    context "Non-existent key" do
      it "raises an exception" do
        non_existant_key = "non-existant-configmap-#{uuid.generate}"

        Given "a non-existant configmap '#{non_existant_key}'" do
        end

        When "attempting to read the value of the key '#{non_existant_key}'" do
        end

        Then "a 'not found' exception is raised" do
          expect {
            keyvalueK8s.update_key(non_existant_key, {'answer' => '42'})
          }.to raise_exception(Exception, /not found/)
        end
      end
    end
  end
end
