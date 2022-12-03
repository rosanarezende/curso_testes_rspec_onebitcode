FactoryBot.define do
  factory :user do
    # poderia usar FFaker::Name.first_name, mudamos apenas para conhecer outros métodos do FFaker
    nickname { FFaker::Lorem.word } 

    # com o %i ele devolve um simbolo, mas para não termos uma inconsistência nos testes precisamos devolver uma string usando %w
    kind { %w[knight wizard].sample }

    level { FFaker::Random.rand(1..99) }
  end
end
