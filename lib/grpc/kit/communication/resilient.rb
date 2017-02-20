require 'grpc/errors'
require 'google/cloud/errors'

module GRPC
  module Kit
    module Communication
      module Resilient
        ERRORS = [
          GRPC::BadStatus,
          Google::Cloud::UnavailableError,
          Google::Cloud::InternalError
        ].freeze

        def resilient(limit: 16)
          tries ||= 0
          yield
        # From Datastore documentation:
        # - UNAVAILABLE;
        # - Server returned an error;
        # - Retry using exponential backoff.
        rescue *ERRORS => e
          tries += 1
          exponential_backoff(tries, limit: limit) && retry
          raise
        end

        # See: https://en.wikipedia.org/wiki/Exponential_backoff
        def exponential_backoff(tries, limit:)
          # Retry few times before going exponential
          return true if tries <= 3

          # Check whether it's reached the ceiling
          if tries < limit
            retry_time = 0.1 * rand(1 << tries) # random number between 0 and 2**N − 1
            sleep(retry_time)
          end
        end
      end
    end
  end
end
