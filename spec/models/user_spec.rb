require 'rails_helper'

RSpec.describe User, type: :model do
  it "is invalid if the level is not between 1 and 99" do
    # :user foi definido em spec/factories/user.rb
    # build chama o User.new
    user = build(:user, level: FFaker::Random.rand(100..999))

    expect(user).to_not be_valid
  end

  it "returns the correct hero title" do
    # esse teste não dá pra encurtar muito, pois precisamos ter essas variáveis
    nickname = FFaker::Name.first_name
    kind = %i[knight wizard].sample
    level = FFaker::Random.rand(1..99)

    # create chama o User.create
    user = create(:user, nickname: nickname, kind: kind, level: level)

    expect(user.title).to eq("#{kind} #{nickname} ##{level}")
  end
end
