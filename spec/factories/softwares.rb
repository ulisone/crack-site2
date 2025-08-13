FactoryBot.define do
  factory :software do
    title { "MyString" }
    description { "MyText" }
    version { "MyString" }
    developer { "MyString" }
    official_site { "MyString" }
    file_size { 1 }
    os_requirements { "MyString" }
    published { false }
    downloads_count { 1 }
    category { nil }
  end
end
