require 'rest_client'
require "rexml/document"
require 'picasa'

class HomeController < ApplicationController

  before_filter :set_user_id

  def set_user_id
    if(current_user)
      params[:user_id] = current_user.email.split('@')[0]
    end  
  end

  def index
  end

  def list

  	@albums = Picasa.list_albums(params)		  

	end

  def list_images

  	@images = Picasa.list_photos(params)		  

  end

  def new_comment

    Picasa.new_comment(params.merge(:token => session["token"]))

    redirect_to :controller => 'home', :action => 'list_images', :album_id => params[:album_id]
  
  end 


end
