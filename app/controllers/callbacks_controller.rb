class CallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :verify_authenticity_token, :only => [:google]

  def google_oauth2
    @user = User.find_for_open_id(request.env["omniauth.auth"], current_user)

    puts "request " + request.env.to_s

    auth_data = request.env["omniauth.auth"]

    puts "TOKEN " + auth_data.credentials.token
    session["token"] = auth_data.credentials.token
    session["devise.google_data"] = auth_data

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to new_user_registration_url
    end
  end
end
