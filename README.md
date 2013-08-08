# MemcacheCheck

  This gem is intended to help find problems with Memcached servers.
  MemcacheCheck runs a series of set and get commands against a Memcached
  server and validates the data returned. It also returns the benchmark
  time that it takes to run the get and set commands to help find slow
  responding servers.


## Installation

Add this line to your application's Gemfile:

    gem 'memcache_check'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install memcache_check


## Usage

Create an instance of MemcacheCheck::Checker and pass in an argument of
the server's IP address as a string. If you don't pass an IP address in it
will default to localhost.  You can optionally pass in a second argument of
the port number if you are running memcached on a non-standard port.

Once you have an instance you simply run the start method and pass it the
number of key value pairs you want to test against the server. If you don't
pass a value in it will default to 50.

The start method returns an array of 3 numbers:

    - Number of passing set/get pairs
    - Number of failing set/get pairs
    - Benchmark time to run the test

example.rb

    require 'memcache_check'

    memcache_check = MemcacheCheck::Checker.new('127.0.0.1')
    passes, fails, time = memcache_check.start(500)

    puts "Number of passes: #{passes}"
    puts "Number of failures: #{fails}"
    puts "Total time: #{time} seconds"

Running on my local machine this produces:

    Number of passes: 500
    Number of failures: 0
    Total time: 0.61212 seconds



## Contributing

    1. Fork it
    2. Create your feature branch (`git checkout -b my-new-feature`)
    3. Commit your changes (`git commit -am 'Add some feature'`)
    4. Push to the branch (`git push origin my-new-feature`)
    5. Create new Pull Request
