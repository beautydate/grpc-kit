require 'grpc/kit/queue/worker'

class MyOtherWorker
  include GRPC::Kit::Queue::Worker

  def call
    puts 'ping'
  end
end
