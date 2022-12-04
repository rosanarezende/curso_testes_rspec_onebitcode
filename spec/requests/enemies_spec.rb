require 'rails_helper'

RSpec.describe "Enemies", type: :request do

  describe "GET /enemies" do

    it "returns success status" do
      get enemies_path
      expect(response).to have_http_status(200)
    end

    it "the enemies's name is present" do
      enemies = create_list(:enemy, 3)
      get enemies_path
      enemies.each do |enemy|
        expect(response.body).to include(enemy.name)
      end
    end

    it "returns enemies's link" do
      enemies = create_list(:enemy, 3)
      get enemies_path
      enemies.each do |enemy|
        expect(response.body).to include("enemies/#{enemy.id}")
      end
    end
  end

  describe "POST /weapons" do
    context "when it has valid params" do
      let(:enemy) { create(:enemy) } 
      let(:enemy_attributes) { attributes_for(:enemy) } 

      it "creates the enemies with correct attributes" do
        post enemies_path, params: enemy_attributes
        expect(Enemy.last).to have_attributes(enemy_attributes)
      end
    end

    context "when it has no valid params" do
      it "does not create the enemies" do
        expect{
          post enemies_path, params: { enemy: { level: '', power_base: '', power_step: '', name: '' } }
        }.to_not change(Enemy, :count)
      end
    end
  end

  describe "GET /enemies/:id" do
    let(:enemy) { create(:enemy) } 

    it "returns success status" do
      get enemy_path(enemy)
      expect(response).to have_http_status(200)
    end

    it "returns the enemy's name" do
      get enemy_path(enemy)
      expect(response.body).to include(enemy.name)
    end

    it "returns the enemy's level" do
      get enemy_path(enemy)
      expect(response.body).to include(enemy.level.to_s)
    end

    it "returns the enemy's kind" do
      get enemy_path(enemy)
      expect(response.body).to include(enemy.kind)
    end

    it "returns the enemy's power" do
      get enemy_path(enemy)
      expect(response.body).to include(enemy.current_power.to_s)
    end
  end

  describe "PUT /enemies" do

    context "when the enemies exists" do
      let(:enemy) { create(:enemy) } 
      let(:enemy_attributes) { attributes_for(:enemy) } 
      before { put "/enemies/#{enemy.id}", params: enemy_attributes }

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "updates the enemy" do
        expect(enemy.reload).to have_attributes(enemy_attributes)
      end

      it "returns the updated enemy" do
        expect(enemy.reload).to have_attributes(json.except("created_at", "updated_at"))
      end
    end

    context "when the enemy does not exist" do
      before(:each) { put "/enemies/0", params: attributes_for(:enemy) }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end

  describe "DELETE /enemies" do
    context "when the enemies exists" do
      let(:enemy) { create(:enemy) }
      before(:each) { delete "/enemies/#{enemy.id}" }

      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end

      it "destroy the record" do
        expect { enemy.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the enemy does not exist" do
      before(:each) { delete "/enemies/0" }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end
end
