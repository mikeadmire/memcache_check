require "memcache_check/version"
require 'dalli'

module MemcacheCheck
  class TestServer

    def initialize(host = 'localhost', port = 11211)
      @memcache = Dalli::Client.new("#{host}:#{port}")
    end

    def generate_key
      "MemcacheCheck" + Time.now.strftime("%s%6N")
    end

    def set(key, value)
      @memcache.set(key, value)
    end

    def get(key)
      @memcache.get(key)
    end

  end
end
