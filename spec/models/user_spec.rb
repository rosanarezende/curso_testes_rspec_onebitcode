require 'rails_helper'

RSpec.describe User, type: :model do
  it "is invalid if the level is not between 1 and 99" do
    user = User.create(nickname: "John", kind: :wizard, level: 100)
    expect(user).to be_invalid
  end

  it "returns the correct hero title" do
    user = User.new(kind: "knight", nickname: "Sir Lancelot", level: 42)
    expect(user.title).to eq("knight Sir Lancelot #42")
  end
end
