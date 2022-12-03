Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # criar rotas pros nossos métodos
  resources :users, only: [:index, :create]

  resources :weapons, only: [:index, :create, :destroy, :show]

  # criar rota para a página inicial
  root 'weapons#index'
end
