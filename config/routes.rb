Rails.application.routes.draw do


 	devise_for :admin_users, ActiveAdmin::Devise.config
 	ActiveAdmin.routes(self)

 	get 'oauth_test/index'
  root 'top#index'
	get '/notes/hashtag/:tag_name', to: "users/notes#hashtag"#リンクをつけたハッシュタグへのrouting
  post '/subscriptions/new' => 'users/subscriptions#registration_payjp'
  post '/subscriptions' => 'users/subscriptions#monthly_subscription'




	#github認証のため以下記載
	devise_for :users, controllers: {
		registrations: "users/registrations",
		omniauth_callbacks: "users/omniauth_callbacks"
	}

	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  	scope module: :users do
  		resources :hashtags, :my_notes, :note_hashtags, :points, :users, :subscriptions, :bookmarks
  	end

  	scope module: :users do
  		resources :notes do
  			resources :reviews, :postscripts
  		end
  	end


  	namespace :admins do
  		resources :bookmarks, :hashtags, :my_notes, :note_hashtags, :notes, :points, :postscripts, :reviews, :users
  	end

end
