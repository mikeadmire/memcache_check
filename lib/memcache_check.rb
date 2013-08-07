require "memcache_check/version"

module MemcacheCheck
  class TestServer

    def initialize(host = 'localhost')

    end

    def generate_key
      "MemcacheCheck" + Time.now.strftime("%s%6N")
    end

    def set(key, value)
    end

    def get(key)
    end

  end
end
