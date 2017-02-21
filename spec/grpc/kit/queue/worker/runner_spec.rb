require 'spec_helper'

RSpec.describe GRPC::Kit::Queue::Worker::Runner do
  let(:pubsub)       { double(:pubsub, topic: topic) }
  let(:topic)        { double(:topic, subscription: subscription) }
  let(:subscription) { double(:subscription, listen: true) }
  let(:params)       { { topic: topic_name, worker: worker_class } }
  let(:topic_name)   { 'topic_name' }
  let(:worker_class) { 'Class' }

  subject { described_class.new(params) }

  before do
    subject.instance_variable_set :@pubsub, pubsub
  end

  it '.run!' do
    expect(described_class)
      .to receive(:new)
            .with(params)
            .and_return(double(:runner, run!: true))

    described_class.run! params
  end

  describe '#run!' do
    context 'when does not exist worker_class' do
      let(:worker_class) { 'OhBlaDih' }

      it 'receives exit' do
        expect(subject).to receive(:exit)

        subject.run!
      end
    end

    it 'when does not exist topic creates a new' do
      allow(pubsub).to receive(:topic).and_return(nil)
      expect(pubsub).to receive(:create_topic).with(topic_name).and_return(topic)

      subject.run!
    end

    it 'when exists topic use existent' do
      expect(pubsub).to_not receive(:create_topic)

      subject.run!
    end

    it 'when does not exist subscription creates a new' do
      allow(topic).to receive(:subscription).and_return(nil)
      expect(topic).to receive(:subscribe).with("#{topic_name}.#{worker_class}").and_return(subscription)

      subject.run!
    end

    it 'when exists subscription use existent' do
      expect(topic).to_not receive(:subscribe)

      subject.run!
    end
  end
end
