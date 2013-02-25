OauthTest::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

	root :to => "home#index"

	match "/list" => "home#list"
	match "/list-images/:albumId" => "home#list_images"
	match "/list-comments/:albumId/:imageId" => "home#list_comments"
	match "/new-comment/:albumId/:imageId" => "home#new_comment"
end
