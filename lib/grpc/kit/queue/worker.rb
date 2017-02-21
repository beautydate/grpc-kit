require_relative 'worker/runner'

module GRPC
  module Kit
    module Queue
      module Worker
        def self.included(klass)
          @@workers ||= []
          @@workers << klass
        end

        def self.list
          @@workers
        rescue NameError
          []
        end

        def call
          raise NotImplemented.new
        end
      end
    end
  end
end
