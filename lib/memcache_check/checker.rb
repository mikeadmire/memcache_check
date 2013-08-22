module MemcacheCheck
  class Checker
    def initialize(hostname = 'localhost', port = '11211')
      @server = Server.new(hostname, port)
    end

    def start(num_times = 50)
      @server.benchmark(num_times)
      [@server.passes, @server.fails, @server.time.real]
    end

    def self.group_benchmark(*args)
      group = []
      args.each do |hostname|
        server = Server.new(hostname)
        server.benchmark(100)
        group << server
      end
      group
    end
  end
end
