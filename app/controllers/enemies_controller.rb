class EnemiesController < ApplicationController
  # se tivéssemos outros métodos, poderíamos dizer quais métodos usariam o set_enemy ==> only: [:update, :destroy]
  before_action :set_enemy

  def update
    if @enemy.update(enemy_params)
      render json: @enemy 
      # tinha "", status :ok", mas deu erro nos testes
      # mas como o status :ok é o padrão, então não precisa colocar
    else
      render json: { errors: @enemy.errors }, status: :unprocessable_entity # 422
    end
  end

  def destroy
    @enemy.destroy
    head 204 # ou :no_content => é o status de sucesso, mas sem conteúdo

    # OBS: se algo der errado, com o id incorreto, vai ser pego pelo rescue do set_enemy
  end

  private

  # aqui filtramos os parâmetros recebidos pela web, para não permitir que o usuário envie dados que não queremos
  def enemy_params
    params.permit(:name, :power_base, :power_step, :level, :kind)
  end

  def set_enemy
    @enemy = Enemy.find(params[:id])
  # o rescue captura o erro e não deixa travar a aplicação
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found # 404
  end
end
