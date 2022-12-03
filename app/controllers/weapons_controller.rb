# rodei:
# rails g controller weapons index create --no-helper --no-assets --no-controller-specs --no-view-specs --skip-routes
# teria facilitado eu usar além de index e create, show, update e destroy

class WeaponsController < ApplicationController
  # set_weapon é um before_action: antes de executar quaisquer desses métodos, ele executa o set_weapon
  before_action :set_weapon, only: [:show, :update, :destroy]

  def index
    @weapons = Weapon.all
  end

  def create
    @weapon = Weapon.create(weapon_params)
    redirect_to weapons_path
  end

  # não sei se funciona
  def destroy
    @weapon.destroy
    redirect_to weapons_path
  end

  # devolve uma página com todos os detalhes de uma das armas
  # não sei se funciona
  def show
    @weapon
  end

  def update
    @weapon.update!(weapon_params)
  end

  private

  def set_weapon
    @weapon = Weapon.find(params[:id])
  end

  def weapon_params
    params.require(:weapon).permit(:name, :level, :power_base, :power_step, :description)
  end
end
