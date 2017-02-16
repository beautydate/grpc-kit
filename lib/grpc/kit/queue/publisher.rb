require 'google/cloud/pubsub'

module GRPC
  module Kit
    module Queue
      module Publisher
        module_function

        @@topics = {}

        def publish(topic_name, message)
          topic(topic_name).publish(message)
        end

        def topic(name)
          @@topics[name] ||= pubsub.topic(name) || pubsub.create_topic(name)
        end

        def pubsub
          @@pubsub ||= Google::Cloud::Pubsub.new
        end
      end
    end
  end
end
