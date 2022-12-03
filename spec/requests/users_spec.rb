# Testar controllers que devolvem telas ou fazem  redirecionamentos
require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "returns success status" do
      # faz uma chamada GET para a rota /users
      get users_path

      # e devolver com sucesso
      expect(response).to have_http_status(200)
    end

    it "the user's title is present" do
      # jeito do copylot - só um usuário
      # user = create(:user, nickname: "John", level: 1, kind: :knight)
      # get users_path
      # expect(response.body).to include(user.title)

      # outro jeito - vários usuários
      users = create_list(:user, 3)
      get users_path
      users.each do |user|
        expect(response.body).to include(user.title)
      end
    end
  end

  describe "POST /users" do
    context "when it has valid params" do
      it "creates the user with correct attributes" do
        user_attributes = FactoryBot.attributes_for(:user) # funciona sem o FactoryBot.
        post users_path, params: { user: user_attributes }
        expect(User.last).to have_attributes(user_attributes)
      end
    end

    context "when it has no valid params" do
      it "does not create the user" do
        expect{
          post users_path, params: { user: { level: '', kind: '', name: '' } }
        }.to_not change(User, :count)
      end
    end
  end
end

