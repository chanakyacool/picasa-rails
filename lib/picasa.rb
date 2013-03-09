require 'rubygems'
require 'rest_client'
require "rexml/document"
require 'ostruct'

class Picasa
  
  def self.list_albums(options)

    xml = RestClient.get "https://picasaweb.google.com/data/feed/api/user/#{options[:user_id]}"
    parsed_document = Hpricot.parse(xml)

    albums = []

    (parsed_document/:entry).each do |album|
      albums << { "album_id" => album.at('gphoto:id').inner_text,
            "title" => album.at('title').inner_text,
            "thumb" => album.at('//media:thumbnail').attributes['url'] 
            }   
    end 
    albums       
  end
  
  def self.list_photos(options)
    album_id = options[:album_id]
    xml = RestClient.get "https://picasaweb.google.com/data/feed/api/user/#{options[:user_id]}/albumid/#{album_id}"
    parsed_document = Hpricot.parse(xml)
      
    images  = []
    (parsed_document/:entry).take(3).each do |album|  
         photo_id = album.at('gphoto:id').inner_text
         comments = list_comments(options.merge(:photo_id => photo_id))
         images << Photo.new(:album_id => album_id, :photo_id => album.at('gphoto:id').inner_text, :content => album.at('content').attributes['src'], :comments => comments)   
    end
    images
  end

  def self.list_comments(options)
    xml = RestClient.get "https://picasaweb.google.com/data/feed/api/user/#{options[:user_id]}/albumid/#{options[:album_id]}/photoid/#{options[:photo_id]}?kind=comment"
    
    parsed_document = Hpricot.parse(xml)

    comments = []

    (parsed_document/:entry).each do |album|
      comments <<  Comment.new( :name => album.at('/author/name').inner_text , :content => album.at('content').inner_text )
                    
                    
    end        
    comments || []                   
  end

  def self.new_comment(options)
    url = "https://picasaweb.google.com/data/feed/api/user/#{options[:user_id]}/albumid/#{options[:album_id]}/photoid/#{options[:photo_id]}"
 
    body = <<-MLS
    <entry xmlns='http://www.w3.org/2005/Atom'>
      <content>#{options[:comment_content]}</content>
      <category scheme="http://schemas.google.com/g/2005#kind"
        term="http://schemas.google.com/photos/2007#comment"/>
    </entry>
    MLS

    RestClient.post url, body.strip!, { :content_type => "application/atom+xml", 'Authorization' => "OAuth #{options[:token]}" }
  end  
end

class Comment < OpenStruct
    @content
    @author
end

class Photo < OpenStruct
    @album_id
    @photo_id
    @src
    @comments
end

class Album < OpenStruct
    @album_id
    @title
    @thumb
end


