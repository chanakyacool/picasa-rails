require 'spec_helper'

describe "picasa" do
	
	let(:albums_xml) { File.open("./spec/xmls/picasa_albums.xml").read }

	it "returns a list of albums" do
		RestClient.stub(:get).and_return(albums_xml)
		albums = Picasa.list_albums({})
		albums.size.should eq(3)

		albums.first["title"].should eq("Profile Photos")
		albums.first["album_id"].should eq("5624490059999362961")
		albums.first["thumb"].should eq("https://lh4.googleusercontent.com/-q8pzZ7qyaB0/Tg4z6OT6P5E/AAAAAAAAErQ/lfILM1Uv9SE/s160-c/ProfilePhotos.jpg")
  	end	

end