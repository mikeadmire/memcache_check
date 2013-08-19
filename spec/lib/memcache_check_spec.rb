require 'spec_helper'
require 'memcache_check'


describe MemcacheCheck do

  describe "Checker" do
    before(:each) do
      @checker = MemcacheCheck::Checker.new
    end

    it { MemcacheCheck::Checker.should respond_to(:new) }

    describe "start" do
      it { @checker.should respond_to(:start).with(1).arguments }

      it "returns an array" do
        expect(@checker.start).to be_an_instance_of(Array)
      end

      it "returns an array with 3 numeric elements" do
        passes, fails, time = @checker.start
        expect(passes).to be_an_instance_of(Fixnum)
        expect(fails).to be_an_instance_of(Fixnum)
        expect(time).to be_an_instance_of(Float)
      end

      it "passes and fails should add up to correct number" do
        passes, fails, time = @checker.start(50)
        expect(passes + fails).to eq(50)
      end

      it "passes while running locally" do
        passes, fails, time = @checker.start(50)
        expect(passes).to eq(50)
      end
    end # context 'start'

    describe "group_benchmark" do
      before(:each) do
        @response_array = MemcacheCheck::Checker.group_benchmark('localhost', '127.0.0.1', 'localhost')
      end

      it { MemcacheCheck::Checker.should respond_to(:group_benchmark) }

      it "returns an array the same length as the number of hostname arguments" do
        expect(@response_array.length).to eq(3)
      end

      it "returns an array of Server objects" do
        expect(@response_array.first).to be_an_instance_of(MemcacheCheck::Server)
      end

      it "passes and fails should add up to the correct number" do
        @response_array.each do |i|
          expect(i.passes + i.fails).to eq(100)
        end
      end

      it "passes every time when running local" do
        @response_array.each do |i|
          expect(i.passes).to eq(100)
        end
      end

      it "response hostname and time are populated" do
        @response_array.each do |i|
          expect(i.hostname).to_not be_nil
          expect(i.time).to be_an_instance_of(Benchmark::Tms)
        end
      end

      it "localhost should be close to the same twice in a row" do
        first = @response_array[0]
        second = @response_array[1]
        third = @response_array[2]
        expect(first.time.real.round(1)).to eq(second.time.real.round(1))
        expect(second.time.real.round(1)).to eq(third.time.real.round(1))
      end
    end # group_benchmark

  end # Checker

  context "Server" do
    before(:each) do
      @tester = MemcacheCheck::Server.new('localhost', '11211')
    end

    it "can be instantiated" do
      expect(@tester).to be_an_instance_of(MemcacheCheck::Server)
    end

    it { @tester.should respond_to(:set).with(2).arguments }
    it { @tester.should respond_to(:get).with(1).argument }

    it "set and retrieve data from memcached" do
      key = "abc123"
      value = {name: 'Mike Admire',
        text: "Lorem ipsum dolor sit amet, consectetur adipisicing" }
      @tester.set(key, value)
      expect(@tester.get(key)).to eq(value)
    end
  end # context 'Server'


  describe "Utils" do
    it { MemcacheCheck::Utils.new.should respond_to :generate_key_value_pair }

    describe "generate_key_value_pair" do
      before(:each) do
        @key, @data = MemcacheCheck::Utils.new.generate_key_value_pair
      end

      context "key" do
        it "can generate an appropriate sized key" do
          expect(@key.length).to be >= 25
        end

        it "starts with the string MemCacheCheck in key" do
          expect(@key).to start_with("MemcacheCheck")
        end

        it "is unique" do
          key1 = MemcacheCheck::Utils.new.generate_key_value_pair.first
          key2 = MemcacheCheck::Utils.new.generate_key_value_pair.first
          key3 = MemcacheCheck::Utils.new.generate_key_value_pair.first
          expect(@key).to_not eq(key1)
          expect(@key).to_not eq(key2)
          expect(@key).to_not eq(key3)
          expect(key1).to_not eq(key2)
          expect(key1).to_not eq(key3)
          expect(key2).to_not eq(key3)
        end
      end # context 'key'

      context "value" do
        it "generates a data hash" do
          expect(@data).to be_an_instance_of(Hash)
        end

        it "is a reasonable amount of data" do
          expect(@data.length).to be >= 5
          expect(@data.to_s.length).to be >= 500
        end

        it "is unique" do
          data1 = MemcacheCheck::Utils.new.generate_key_value_pair.last
          data2 = MemcacheCheck::Utils.new.generate_key_value_pair.last
          data3 = MemcacheCheck::Utils.new.generate_key_value_pair.last
          expect(@data).to_not eq(data1)
          expect(@data).to_not eq(data2)
          expect(@data).to_not eq(data3)
          expect(data1).to_not eq(data2)
          expect(data1).to_not eq(data3)
          expect(data2).to_not eq(data3)
        end
      end # context 'value'

    end # generate_key_value_pair
  end # Utils

end
