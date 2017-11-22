Rails.application.routes.draw do
	get 'products/weixin'
	post "/products/receive_message" =>"products#receive_message"
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
