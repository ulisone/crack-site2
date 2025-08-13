FactoryBot.define do
  factory :category do
    name { "MyString" }
    slug { "MyString" }
    description { "MyText" }
    position { 1 }
    softwares_count { 1 }
  end
end
