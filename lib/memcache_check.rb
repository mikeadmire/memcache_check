require "memcache_check/version"
require 'dalli'
require 'faker'
require 'benchmark'

module MemcacheCheck
    class Checker
        def initialize(server = 'localhost', port = '11211')
            @server = Server.new(server, port)
        end

        def start(num_times = 50)
            passes = 0
            fails = 0
            time = Benchmark.measure do
                num_times.times do
                    key, value = prepare_data
                    @server.set(key, value)
                    if is_valid?(key, value)
                        passes += 1
                    else
                        fails += 1
                    end
                end
            end
            [passes, fails, time.real]
        end

        def prepare_data
            [Utils.generate_key, Utils.generate_test_data]
        end

        def is_valid?(key, value)
            value == @server.get(key)
        end
    end

    class Server
        def initialize(host, port)
            @memcache = Dalli::Client.new("#{host}:#{port}")
        end

        def set(key, value)
            @memcache.set(key, value)
        end

        def get(key)
            @memcache.get(key)
        end
    end

    class Utils
        def self.generate_key
            "MemcacheCheck" + Time.now.strftime("%s%6N")
        end

        def self.generate_test_data
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
