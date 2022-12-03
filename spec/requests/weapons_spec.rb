# - criar testes de api (não estava no desafio)
# rails generate rspec:request Weapon
require 'rails_helper'

RSpec.describe "Weapons", type: :request do
  describe "GET /weapons" do
    it "returns success status" do
      get weapons_path
      expect(response).to have_http_status(200)
    end

    it "the user's title is present" do
      weapons = create_list(:weapon, 3)
      get weapons_path
      weapons.each do |weapon|
        expect(response.body).to include(weapon.name)
      end
    end
  end

  describe "POST /weapons" do
    context "when it has valid params" do
      it "creates the user with correct attributes" do
        weapon_attributes = FactoryBot.attributes_for(:weapon)
        post weapons_path, params: { weapon: weapon_attributes }
        expect(Weapon.last).to have_attributes(weapon_attributes)
      end
    end

    context "when it has no valid params" do
      it "does not create the user" do
        expect{
          post weapons_path, params: { weapon: { level: '', power_base: '', power_step: '', name: '' } }
        }.to_not change(Weapon, :count)
      end
    end
  end
end
