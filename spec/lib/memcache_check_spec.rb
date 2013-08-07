require 'spec_helper'
require 'memcache_check'
require 'ostruct'


describe MemcacheCheck do

  context "TestServer" do
    before(:each) do
      @tester = MemcacheCheck::TestServer.new
    end

    it "can be instantiated" do
      expect(@tester).to be_an_instance_of(MemcacheCheck::TestServer)
    end

    it { @tester.should respond_to(:set).with(2).arguments }
    it { @tester.should respond_to(:get).with(1).argument }
    it { @tester.should respond_to :generate_key }

    it "set and retrieve data from memcached" do
      key = @tester.generate_key
      value = OpenStruct.new(name: "Mike Admire", website: "http://mikeadmire.com/")
      @tester.set key, value
      expect(@tester.get(key)).to eq(value)
    end

    context "generate_key" do

      it "can generate an appropriate sized key" do
        expect(@tester.generate_key.length).to be(29)
      end

      it "starts with the string MemCacheCheck in key" do
        expect(@tester.generate_key).to start_with("MemcacheCheck")
      end

      it "is unique" do
        test1 = MemcacheCheck::TestServer.new
        test2 = MemcacheCheck::TestServer.new
        test3 = MemcacheCheck::TestServer.new
        expect(@tester.generate_key).to_not eq(test1.generate_key)
        expect(@tester.generate_key).to_not eq(test2.generate_key)
        expect(@tester.generate_key).to_not eq(test3.generate_key)
        expect(test1.generate_key).to_not eq(test2.generate_key)
        expect(test1.generate_key).to_not eq(test3.generate_key)
        expect(test2.generate_key).to_not eq(test3.generate_key)
      end
    end # generate_key

  end # TestServer
  
end
