FactoryBot.define do
  factory :download do
    software { nil }
    ip_address { "MyString" }
    user_agent { "MyString" }
    file_name { "MyString" }
  end
end
