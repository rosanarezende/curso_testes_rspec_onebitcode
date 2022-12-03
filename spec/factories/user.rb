FactoryBot.define do
  factory :user do
    # poderia usar FFaker::Name.first_name, mudamos apenas para conhecer outros métodos do FFaker
    nickname { FFaker::Lorem.word } 
    kind { %i[knight wizard].sample }
    level { FFaker::Random.rand(1..99) }
  end
end
