# Criando um controller básico
# rails g controller users index create --no-helper --no-assets --no-controller-specs --no-view-specs --skip-routes

class UsersController < ApplicationController
  # lista todos os usuários
  def index
    @users = User.all
  end

  # permite a criação de um novo usuário
  def create
    @user = User.create(user_params)
    # redireciona para a página de usuários (index)
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :level, :kind)
  end
end
