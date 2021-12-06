FactoryBot.define do
  factory :user1, class: User do
    name { 'テストユーザー' }
    email { 'test-user+1@example.com' }
    password { 'password' }
  end
end