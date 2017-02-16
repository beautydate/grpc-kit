require 'spec_helper'

RSpec.describe GRPC::Kit::Queue::Publisher do
  let(:pubsub)     { double(:pubsub, topic: topic) }
  let(:topic)      { double(:topic) }
  let(:topic_name) { 'topic_name' }

  before do
    subject.class_variable_set :@@topics, {}
    subject.class_variable_set :@@pubsub, pubsub
  end

  context 'when topic does not exist' do
    let(:topic)  { double(:created_topic, publish: true) }

    it 'creates a new topic' do
      expect(pubsub).to receive(:topic).with(topic_name).and_return(nil)
      expect(pubsub).to receive(:create_topic).with(topic_name).and_return(topic)

      subject.publish topic_name, 'message'
    end
  end

  context 'when topic exist' do
    let(:topic)  { double(:existent_topic, publish: true) }

    it 'use existent topic' do
      expect(pubsub).to receive(:topic).with(topic_name).and_return(topic)
      expect(pubsub).to_not receive(:create_topic)

      subject.publish topic_name, 'message'
    end
  end

  it 'publish message to topic' do
    expect(subject).to receive(:topic).with(topic_name).and_return(topic)
    expect(topic).to receive(:publish).with('message')

    subject.publish topic_name, 'message'
  end
end
