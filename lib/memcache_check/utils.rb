require 'faker'

module MemcacheCheck
  module Utils
    extend self

    def generate_key_value_pair
      [generate_key, generate_test_data]
    end

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
