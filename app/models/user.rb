class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and
  devise :token_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def self.find_for_open_id(access_token, signed_in_resource=nil)
		data = access_token['info']

		if user = User.where(:email => data['email']).first
		  return user
		else #create a user with stub pwd
		  User.create!(:email => data['email'], :password => Devise.friendly_token[0,20])
		end
	end

#	def self.new_with_session(params, session)
#		super.tap do |user|
#		  if data = session['devise.googleapps_data'] && session['devise.googleapps_data']['user_info']
#		    user.email = data['email']
#		  end
#		end
#	end

end
