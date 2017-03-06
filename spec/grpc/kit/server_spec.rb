require 'spec_helper'

RSpec.describe GRPC::Kit::Server do
  it '.run' do
    allow(ENV).to receive(:fetch).with('PORT').and_return('8080')

    rpc_server = double(:rpc_server)
    expect(rpc_server).to receive(:add_http2_port).with('0.0.0.0:8080', :this_port_is_insecure)
    expect(rpc_server).to receive(:handle).with(Class)
    expect(rpc_server).to receive(:run_till_terminated)
    expect(GRPC::RpcServer).to receive(:new).and_return(rpc_server)

    expect(GRPC.logger).to receive(:info).with('Listening insecurely on 0.0.0.0:8080')

    described_class.run(Class)
  end
end
