require "memcache_check/version"
require 'dalli'
require 'faker'

module MemcacheCheck
  class Server
    def initialize(host = 'localhost', port = 11211)
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
        bio: Faker::Lorem.words(num = 50).join(", ")
      }
    end
  end
end
