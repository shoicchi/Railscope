Rails.application.routes.draw do

	get 'top' => 'top#top'
	devise_for :users
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  	scope module: :users do
  		resources :bookmarks, :hashtags, :monthly_fees, :my_notes, :note_hashtags, :notes, :points, :postscripts, :reviews, :users
  	end
end
