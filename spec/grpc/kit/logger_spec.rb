require 'spec_helper'

RSpec.describe GRPC::Kit::Logger do
  it 'exposes logger to GRPC' do
    expect(GRPC.logger).to be_instance_of(Logger)
  end

  it 'integrates with GRPC and sends log to STDOUT' do
    expect do
      GRPC.logger.info('my message')
    end.to output(an_instance_of(String)).to_stdout
  end
end
