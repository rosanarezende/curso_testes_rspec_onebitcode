# - criar testes de api (não estava no desafio)
# rails generate rspec:request Weapon
require 'rails_helper'

RSpec.describe "Weapons", type: :request do
  describe "GET /weapons" do
    it "returns success status" do
      get weapons_path
      expect(response).to have_http_status(200)
    end

    it "the weapons's title is present" do
      weapons = create_list(:weapon, 3)
      get weapons_path
      weapons.each do |weapon|
        expect(response.body).to include(weapon.name)
      end
    end

    it "the weapons's name is present" do
      weapons = create_list(:weapon, 3)
      get weapons_path
      weapons.each do |weapon|
        expect(response.body).to include(weapon.name)
      end
    end

    it "the weapons's current_power is present" do
      weapons = create_list(:weapon, 3)
      get weapons_path
      weapons.each do |weapon|
        expect(response.body).to include(weapon.current_power.to_s)
      end
    end

    it "returns weapon's link" do
      weapons = create_list(:weapon, 3)
      get weapons_path
      weapons.each do |weapon|
        expect(response.body).to include("weapons/#{weapon.id}")
      end
    end
  end

  describe "POST /weapons" do
    context "when it has valid params" do
      it "creates the weapons with correct attributes" do
        weapon_attributes = FactoryBot.attributes_for(:weapon)
        post weapons_path, params: { weapon: weapon_attributes }
        expect(Weapon.last).to have_attributes(weapon_attributes)
      end
    end

    context "when it has no valid params" do
      it "does not create the weapons" do
        expect{
          post weapons_path, params: { weapon: { level: '', power_base: '', power_step: '', name: '' } }
        }.to_not change(Weapon, :count)
      end
    end
  end

  describe "DELETE /Weapons" do
    context "when it passes the correct id" do
      it "successfully deletes de weapon" do
          weapon_attributes = FactoryBot.attributes_for(:weapon)
          post weapons_path, params: { weapon: weapon_attributes }
          expect{
              last = Weapon.last
              delete "#{weapons_path}/#{last.id}"
          }.to change(Weapon, :count)
      end
    end
  end

  describe "SHOW /Weapons" do
    it "the weapon's name is present" do
        weapon = create(:weapon)
        get "#{weapons_path}/#{weapon.id}"
        expect(response.body).to include(weapon.name)
    end

    it "the weapon's level is present" do
        weapon = create(:weapon)
        get "#{weapons_path}/#{weapon.id}"
        expect(response.body).to include("#{weapon.level}")
    end

    it "the weapon's power_base is present" do
        weapon = create(:weapon)
        get "#{weapons_path}/#{weapon.id}"
        expect(response.body).to include("#{weapon.power_base}")
    end

    it "the weapon's power_step is present" do
        weapon = create(:weapon)
        get "#{weapons_path}/#{weapon.id}"
        expect(response.body).to include("#{weapon.power_step}")
    end

    it "the weapon's current_power is present" do
        weapon = create(:weapon)
        get "#{weapons_path}/#{weapon.id}"
        expect(response.body).to include("#{weapon.current_power}")
    end
    
    it "the weapon's title is present" do
        weapon = create(:weapon)
        get "#{weapons_path}/#{weapon.id}"
        expect(response.body).to include(weapon.title)
    end
  end
end
