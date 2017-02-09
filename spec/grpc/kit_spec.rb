require 'spec_helper'

RSpec.describe GRPC::Kit do
  it 'has a version number' do
    expect(GRPC::Kit::VERSION).not_to be_nil
  end
end
