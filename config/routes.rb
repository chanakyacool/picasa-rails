OauthTest::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

	root :to => "home#index"

	match "/list" => "home#list"
	match "/list-images/:album_id" => "home#list_images"
	match "/list-comments/:album_id/:photo_id" => "home#list_comments"
	match "/new-comment/:album_id/:photo_id" => "home#new_comment" #, :as => "new_comment"
end
