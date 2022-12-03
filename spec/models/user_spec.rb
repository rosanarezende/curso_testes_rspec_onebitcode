require 'rails_helper'

RSpec.describe User, type: :model do
  it "is invalid if the level is not between 1 and 99" do
    nickname = FFaker::Name.first_name
    kind = %i[knight wizard].sample
    level = FFaker::Random.rand(100..9999)

    # não usar create pois ele já salva no banco de dados
    # new só cria uma instância do objeto
    user = User.new(nickname: nickname, kind: kind, level: level)

    expect(user).to_not be_valid
  end

  it "returns the correct hero title" do
    nickname = FFaker::Name.first_name
    kind = %i[knight wizard].sample

    # agora colocamos um level válido
    level = FFaker::Random.rand(1..99)

    # aqui usamos o create pois queremos salvar no banco de dados
    user = User.create(nickname: nickname, kind: kind, level: level)

    expect(user.title).to eq("#{kind} #{nickname} ##{level}")
  end
end
