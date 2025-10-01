FactoryBot.define do
  factory :user do
    name { Faker::Name.name}
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { "P@ssw0rd" }
  end
end
