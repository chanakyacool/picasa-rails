require 'rest_client'
require "rexml/document"

class HomeController < ApplicationController

  def index
  end

  def list
  	
  	user_id = current_user.email.split('@')[0]
  	xml = RestClient.get "https://picasaweb.google.com/data/feed/api/user/#{user_id}"
  	parsed_document = Hpricot.parse(xml)

  	@albums = []

  	(parsed_document/:entry).each do |album|
  		@albums << { "albumId" => album.at('gphoto:id').inner_text,
  					"title" => album.at('title').inner_text,
  					"thumb" => album.at('//media:thumbnail').attributes['url'] 
   				  }			  
	end
  end	

  def list_images

  	user_id = current_user.email.split('@')[0]
  	album_id = params[:albumId]
  	xml = RestClient.get "https://picasaweb.google.com/data/feed/api/user/#{user_id}/albumid/#{album_id}"
	  parsed_document = Hpricot.parse(xml)

	  @images = []

  	(parsed_document/:entry).take(3).each do |album|
  		@images << { "albumId" => album_id,
                   "imageId" => album.at('gphoto:id').inner_text,
  					       "content" => album.at('content').attributes['src']
                 }			  
	   end

    #GET https://picasaweb.google.com/data/feed/api/user/userID/albumid/albumID/photoid/photoID?kind=comment

    #@comments = 
  end

  def list_comments
    user_id = current_user.email.split('@')[0]
    album_id = params[:albumId]
    image_id = params[:imageId]
    xml = RestClient.get "https://picasaweb.google.com/data/feed/api/user/#{user_id}/albumid/#{album_id}/photoid/#{image_id}?kind=comment"
    
    parsed_document = Hpricot.parse(xml)

    comments = []

    (parsed_document/:entry).take(3).each do |album|
      comments << { "name" => album.at('/author/name').inner_text,
                   "content" => album.at('content').inner_text
                   }        
     end
    
    render :json => comments

  end	

  def new_comment
    user_id = current_user.email.split('@')[0]
    user_token = session["token"]
    album_id = params[:albumId]
    image_id = params[:imageId]
    post_content = params[:post_content]
    url = "https://picasaweb.google.com/data/feed/api/user/#{user_id}/albumid/#{album_id}/photoid/#{image_id}"
 
    body = <<-MLS
    <entry xmlns='http://www.w3.org/2005/Atom'>
      <content>#{post_content}</content>
      <category scheme="http://schemas.google.com/g/2005#kind"
        term="http://schemas.google.com/photos/2007#comment"/>
    </entry>
    MLS

    #xml = RestClient.post url, body.strip!, { 'Authorization' => "AuthSub #{user_token}" }

    xml = RestClient.post url, body.strip!, { :content_type => "application/atom+xml", 'Authorization' => "OAuth #{user_token}" }

    render "OK"
  end 


end
