require 'spec_helper'

RSpec.describe GRPC::Kit::Communication::Resilient do
  subject do
    class TestResilientCommunication
      include GRPC::Kit::Communication::Resilient

      def raise_error(error, limit = 16)
        resilient(limit: limit) { raise error }
      end
    end

    TestResilientCommunication.new
  end

  it 'retry until limit and raise exception after limit' do
    expect(subject).
      to receive(:exponential_backoff)
           .exactly(5).times
           .and_call_original

    expect {
      subject.raise_error(GRPC::BadStatus.new(13, 'msg'), 5)
    }.to raise_error(GRPC::BadStatus)
  end

  describe 'configured errors' do
    it 'retry for GRPC::BadStatus' do
      expect(subject).
        to receive(:exponential_backoff)
             .exactly(5).times
             .and_call_original

      expect {
        subject.raise_error(GRPC::BadStatus.new(15, 'error'), 5)
      }.to raise_error(GRPC::BadStatus)
    end

    it 'retry for Google::Cloud::UnavailableError' do
      expect(subject).
        to receive(:exponential_backoff)
             .exactly(5).times
             .and_call_original

      expect {
        subject.raise_error(Google::Cloud::UnavailableError.new, 5)
      }.to raise_error(Google::Cloud::UnavailableError)
    end

    it 'retry for Google::Cloud::InternalError' do
      expect(subject).
        to receive(:exponential_backoff)
             .exactly(5).times
             .and_call_original

      expect {
        subject.raise_error(Google::Cloud::InternalError.new, 5)
      }.to raise_error(Google::Cloud::InternalError)
    end
  end

  it 'unconfigured error' do
    expect(subject).to_not receive(:exponential_backoff)

    expect {
      subject.raise_error(RuntimeError.new('msg'))
    }.to raise_error(RuntimeError)
  end
end
