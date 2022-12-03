FactoryBot.define do
  factory :weapon do
    name { FFaker::Product.product_name }
    description { FFaker::Lorem.paragraph }
    level { FFaker::Random.rand(1..99) }
    power_base { [3000, 6000, 9000].sample }
    power_step { 100 }  # power_step { 100 }
  end
end
