FactoryBot.define do
  factory :weapon do
    name { FFaker::Product.product_name }
    level { FFaker::Random.rand(1..99) }
    power_base { FFaker::Random.rand(1000..3000) }
    power_step { FFaker::Random.rand(100..300) }  
  end
end
