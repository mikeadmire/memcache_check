require 'dalli'
require 'benchmark'

module MemcacheCheck
  class Server
    attr_reader :hostname, :port, :passes, :fails, :time

    def initialize(hostname = '127.0.0.1', port = '11211')
      @memcache_client = Dalli::Client.new("#{hostname}:#{port}")
      @hostname = hostname
      @port = port
      @passes = 0
      @fails = 0
    end

    def benchmark(num_times)
      @time = Benchmark.measure do
        num_times.times do
          run_test
        end
      end
    end

    def run_test
      key, value = Utils.generate_key_value_pair
      begin
        set(key, value)
        if is_valid?(key, value)
          @passes += 1
        else
          @fails += 1
        end
      rescue
        @fails += 1
      end
    end

    def set(key, value)
      @memcache_client.set(key, value)
    end

    def get(key)
      @memcache_client.get(key)
    end

    def is_valid?(key, value)
      value == get(key)
    end
  end
end
