# Mini curso de testes Ruby com Rspec

Este repositório tem o conteúdo produzido durante o ()[Mini curso de testes Ruby com Rspec] da (https://onebitcode.com/course/minicurso-de-testes/)[One Bit Code]

# ENEMIES

======

APIs são maneiras de conectar com serviços:
- exemplo: conectar com o Google para traduzir uma frase
- exemplo: conectar com Watson (IBM) para processamento de linguagem natural

Fazemos então testes de request e testes unitários

Iremos testar controllers que devolvem json, que é o padrão principal de APIs

======

Primeiro precisamos preparar nosso ambiente:

1) Vamos criar um novo controller que vai servir como uma API, com 2 métodos principais: update e destroy
```
rails g controller enemies update destroy --no-helper --no-assets --no-controller-specs --no-view-specs --skip-routes
```
- se quiséssemos poderíamos criar outros controllers como `index` e `create`


2) Depois geramos o model
```
rails g model enemy name:string power_base:integer power_step:integer level:integer kind:integer
```


3) E em seguida vamos atualizar o banco de dados
```
rails db:migrate
```


4) Depois fazemos validações dentro de `app/models/enemy.rb`
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


5) Em seguida alteramos o controller em `app/controllers/enemies_controller.rb`
```ruby
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

```


6) Nas rotas `config/routes.rb` adicionamos
```ruby
resources :enemies, only: [:update, :destroy]
```


7) E nas factories `spec/factories/enemies.rb`
```ruby
FactoryBot.define do
  factory :enemy do
    name { FFaker::Lorem.word }
    power_base { FFaker::Random.rand(1..9999) }
    power_step { FFaker::Random.rand(1..9999) }
    level { FFaker::Random.rand(1..99) }
    # cuidado, não tem vírgula aqui
    kind { %w[goblin orc demon dragon].sample }
  end
end
```

===

Tudo pronto, vamos para os testes!


Vamos primeiro gerar os testes de request, que vai gerar o arquivo `spec/requests/enemies_spec.rb`
```
rails g rspec:request Enemy
```


<hr/>
Uma observação antes disso: para facilitar a legibilidade dos testes podemos criar helpers (que são métodos que podem ser reaproveitados ao longo dos testes)

Exemplo disso é para que não precisemos ficar tratando dados da API com JSON.parse

Criamos o arquivo `spec/support/request_helper.rb`
```ruby
module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end
end

```

E pra usar incluir no `rails_helper.rb`
```ruby
# descomentar a linha - dá automaticamente o require em todos os arquivos que estiverem dentro da pasta support
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# e incluir no Rspec.configure
config.include Requests::JsonHelpers, type: :request
```

<hr/>

### UPDATE

Vamos alterar o arquivo `spec/requests/enemies_spec.rb`:

```ruby
require 'rails_helper'

RSpec.describe "Enemies", type: :request do
  describe "PUT /enemies" do

    # quando tento atualizar com o id correto
    context "when the enemies exists" do

      # LET
      # é uma maneira de definir métodos/variáveis que só carrega o valor quando é utilizado e depois do primeiro uso mantém um cache do valor durante todo o teste
      # ela só é criada quando é chamada por um it
      # e pra cada it o valor é reiniciado

      let(:enemy) { create(:enemy) } 
      let(:enemy_attributes) { attributes_for(:enemy) } 

      # HOOKS
      # metodos que permitem a execução de código antes ou depois dos testes (after e before)
      # before(:each) ou simplesmente before
      # exemplo: por default a instância de herói vem com a arma machado, no before posso atualizar para faca e no it verifico se a arma é faca

      # nesse caso chamo o put antes de cada it
      before(:each) { put "/enemies/#{enemy.id}", params: enemy_attributes }

      it "returns status code 200" do
        # === se eu fixer como nos testes de users, com get "enemies_path", vou ter um erro
        # === porque o rails não sabe como montar a url
        # get enemies_path

        # === também tentei
        # enemy = create(:enemy)
        # enemy_attributes = attributes_for(:enemy) # isso é do FactoryBot
        # put "/enemies/#{enemy.id}", params: enemy_attributes

        # pra funcionar foi necessário usar o let e o before
        expect(response).to have_http_status(200)
      end

      it "updates the enemy" do
        # quando eu crio o enemy (create(:enemy)), ele já é salvo no banco de dados
        # e quando eu faço o put, ele já atualiza o banco de dados
        # preciso fazer o .reload para pegar o que foi atualizado
        expect(enemy.reload).to have_attributes(enemy_attributes)

        # também é possível testar um atributo específico
        # expect(enemy.reload.name).to eq(enemy_attributes[:name])
      end

      it "returns the updated enemy" do
        # a API responde via JSON, então preciso converter o JSON para Hash (algo que o Ruby entende)
        # json_response = JSON.parse(response.body)
        # Para que não seja preciso ficar fazendo o JSON.parse(response.body), criei um helper com o método json (tá mais pra cima aqui do README)

        # na retorno tem created_at e updated_at, que não são enviados na requisição
        # então eu dou um except para não testar esses atributos 
        expect(enemy.reload).to have_attributes(json_response.except("created_at", "updated_at"))
      end
    end

    # quando tento atualizar com o id incorreto
    context "when the enemy does not exist" do

      # o id 0 não existe no banco de dados
      before(:each) { put "/enemies/0", params: attributes_for(:enemy) }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        # essa mensagem é a que está no rescue do controller (do próprio ActiveRecord)
        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end
end
```

### DESTROY

```ruby
describe "DELETE /enemies" do
  context "when the enemies exists" do
    let(:enemy) { create(:enemy) }
    before(:each) { delete "/enemies/#{enemy.id}" }

    it "returns status code 204" do
      expect(response).to have_http_status(204)
    end

    it "destroy the record" do
      # expect(Enemy.find_by(id: enemy.id)).to be_nil
      # === ou
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
```
