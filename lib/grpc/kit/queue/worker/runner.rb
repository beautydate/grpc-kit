module GRPC
  module Kit
    module Queue
      module Worker
        class Runner
          def initialize(params)
            @topic_name        = params[:topic]
            @subscription_name = "#{params[:topic]}.#{params[:worker]}"
            @worker_class      = params[:worker]
          end

          def self.run!(params)
            new(params).run!
          end

          def run!
            if worker.nil?
              GRPC.logger.error("class #{@worker_class} does not exist")
              exit
            end

            subscription.listen do |msg|
              worker.new(msg).call
            end
          end

          private

          def worker
            Object.const_get(@worker_class)
          rescue NameError
            nil
          end

          def subscription
            @subscription ||= topic.subscription(@subscription_name) || topic.subscribe(@subscription_name)
          end

          def topic
            @topic ||= pubsub.topic(@topic_name) || pubsub.create_topic(@topic_name)
          end

          def pubsub
            @pubsub ||= Google::Cloud::Pubsub.new
          end
        end
      end
    end
  end
end
