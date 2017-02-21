require 'spec_helper'

RSpec.describe GRPC::Kit::Queue::Worker do
  describe '.list' do
    it 'without workers' do
      expect(described_class.list).to eq []
    end

    it 'with workers' do
      object = Class.new
      object.include described_class

      expect(described_class.list).to include object.class
    end
  end
end
