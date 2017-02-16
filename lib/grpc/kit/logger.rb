require 'logger'

module GRPC
  module Kit
    module Logger
      # TODO Should we use config or env var?
      LOGGER = ::Logger.new(STDOUT)
      # TODO Should we use config or env var?
      LOGGER.level = ::Logger::DEBUG

      def logger
        LOGGER
      end
    end
  end
end

module GRPC
  extend Kit::Logger
end
