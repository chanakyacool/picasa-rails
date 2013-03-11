require 'spec_helper'

describe "picasa" do
	
	let(:albums_xml) { File.open("./spec/xmls/picasa_albums.xml").read }
	let(:photos_xml) { File.open("./spec/xmls/picasa_photos.xml").read }
	let(:comments_xml) { File.open("./spec/xmls/picasa_comments.xml").read }

	it "returns a list of albums" do

		RestClient.stub(:get).and_return(albums_xml)
		
		albums = Picasa.list_albums({})
		albums.size.should eq(3)
		albums.first["title"].should eq("Profile Photos")
		albums.first["album_id"].should eq("5624490059999362961")
		albums.first["thumb"].should eq("https://lh4.googleusercontent.com/-q8pzZ7qyaB0/Tg4z6OT6P5E/AAAAAAAAErQ/lfILM1Uv9SE/s160-c/ProfilePhotos.jpg")
  		
  		RestClient.unstub(:get)
  	end	

	it "returns a list of photos" do

		RestClient.stub(:get).and_return(photos_xml)

		Picasa.stub(:list_comments).and_return([])
		
		photos = Picasa.list_photos(:album_id => '5681617398801456529')

		photos.size.should eq(3)

		photos.first.album_id.should eq("5681617398801456529")
		photos.first.content.should eq("https://lh4.googleusercontent.com/-WoH1ydasEHw/Ttko7M9quvI/AAAAAAAAEEc/4jATgy_qSiw/PRODUCTIVITY.png")
		photos.first.photo_id.should eq("5681617402461862642")
  		
  		RestClient.unstub(:get)
  		Picasa.unstub(:list_comments)
  	end	

	it "returns a list of comments" do

		RestClient.stub(:get).and_return(comments_xml)
		
		comments = Picasa.list_comments({})

		comments.size.should eq(6)
		comments.first.name.should eq("Raphael Miranda")
		comments.first.content.should eq("popop")
  		
  		RestClient.unstub(:get)
  	end	  	

end