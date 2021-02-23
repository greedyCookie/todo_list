FactoryBot.define do
  factory :todo_list_item do
    association :todo_list

    title { FFaker::Lorem.word }
    description { FFaker::Lorem.sentence(4) }
  end
end
