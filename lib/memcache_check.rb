require "memcache_check/version"
require 'dalli'
require 'faker'
require 'benchmark'

module MemcacheCheck
  class Checker
    def initialize(hostname = 'localhost', port = '11211')
      @server = Server.new(hostname, port)
    end

    def start(num_times = 50)
      @server.benchmark(num_times)
      [@server.passes, @server.fails, @server.time.real]
    end
  end

  class Server
    attr_reader :host, :port, :passes, :fails, :time

    def initialize(host = '127.0.0.1', port = '11211')
      @memcache_client = Dalli::Client.new("#{host}:#{port}")
      @host = host
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
      key, value = Utils.new.generate_key_value_pair
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

  class Utils
    def generate_key_value_pair
      [generate_key, generate_test_data]
    end

    private

      def generate_key
        "MemcacheCheck" + Time.now.strftime("%s%6N")
      end

      def generate_test_data
        {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          phone: Faker::PhoneNumber.phone_number,
          city: Faker::Address.city,
          state: Faker::Address.state,
          bio: Faker::Lorem.words(num = 100).join(", ")
        }
      end
  end
end
