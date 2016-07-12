Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'parsexml#index'
  get '/parsexml/show'
  get '1c_exchange.php' => 'parsexml#exchange_1c', action: :exchange_1c
end