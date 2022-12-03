# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# ENEMIES

Vamos criar um novo controller que vai servir como uma API, com 2 métodos principais: update e destroy
```
rails g controller enemies update destroy --no-helper --no-assets --no-controller-specs --no-view-specs --skip-routes
```
- se quiséssemos poderíamos criar outros controllers como `index` e `create`


Depois geramos o model
```
rails g model enemy name:string power_base:integer power_step:integer level:integer kind:integer
```


E em seguida vamos atualizar o banco de dados
```
rails db:migrate
```


Dapois fazemos validações dentro de `app/models/enemy.rb`
```ruby
class Enemy < ApplicationRecord
  enum kind: [ :goblin, :orc, :demon, :dragon ]
  validates :level, numericality: { greater_than: 0, less_than_or_equal_to: 99 }
  validates_presence_of :name, :power_base, :power_step, :level, :kind

  def current_power
    power_base + (power_step * (level - 1))
  end
end
```


Em seguida alteramos o controller em `app/controllers/enemies_controller.rb`
```ruby
class EnemiesController < ApplicationController
  # se tivéssemos outros métodos, poderíamos dizer quais métodos usariam o set_enemy ==> only: [:update, :destroy]
  before_action :set_enemy

  def update
    if @enemy.update(enemy_params)
      render json: @enemy, status :ok # 200
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

```


Nas rotas `config/routes.rb` adicionamos
```ruby
resources :enemies, only: [:update, :destroy]
```


E nas factories `spec/factories/enemies.rb`
```ruby
FactoryBot.define do
  factory :enemy do
    name { FFaker::Lorem.word }
    power_base { FFaker::Random.rand(1..9999) }
    power_step { FFaker::Random.rand(1..9999) }
    level { FFaker::Random.rand(1..99) }
    kind { %w[goblin, orc, demon, dragon].sample }
  end
end
```
