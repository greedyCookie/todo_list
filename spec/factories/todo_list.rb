FactoryBot.define do
  factory :todo_list do
    association :user

    name { FFaker::Lorem.word }
  end
end
