require 'thor'

workers_dir = File.join(Dir.pwd, 'lib', 'workers')
$LOAD_PATH.unshift(workers_dir) unless $LOAD_PATH.include?(workers_dir)

module GRPC
  module Kit
    class Workers < Thor
      desc 'runner <worker> <topic>', 'Run <worker> for <topic>'
      def runner(worker, topic)
        require worker.gsub(/(.)([A-Z])/,'\1_\2').downcase

        Queue::Worker::Runner.run! topic: topic, worker: worker
      end

      desc 'list', 'List available workers'
      def list
        Dir.glob('lib/workers/**/*') do |file|
          require File.basename(file, File.extname(file))
        end

        workers = GRPC::Kit::Queue::Worker.list
        if workers.empty?
          puts 'No available workers'
        else
          workers.each do |worker|
            puts " - #{worker}"
          end
        end
      end
    end

    class Cli < Thor
      desc 'workers SUBCOMMAND ...ARGS', 'run or manage workers'
      subcommand 'workers', Workers
    end
  end
end
