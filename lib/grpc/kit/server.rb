require 'grpc'

module GRPC
  module Kit
    module Server
      module_function

      def run(server_klass)
        GRPC.logger.info("Listening insecurely on 0.0.0.0:#{ENV.fetch('PORT')}")
        s = GRPC::RpcServer.new
        s.add_http2_port("0.0.0.0:#{ENV.fetch('PORT')}", :this_port_is_insecure)
        s.handle(server_klass)
        s.run_till_terminated
      end
    end
  end
end
