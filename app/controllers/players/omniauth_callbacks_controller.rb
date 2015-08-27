class Players::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @player = Player.from_omniauth(request.env["omniauth.auth"])

    sign_in_and_redirect @player, event: :authentication #this will throw if @user is not activated
    set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?

    # if @player.persisted?
    #   flash[:notice] = "SUCCESSS!!!! :D", kind: "Google"
    #   sign_in_and_redirect @player, event: :authentication
    # else
    #   session["devise.google_data"] = request.env["omniauth.auth"]
    #   redirect_to new_user_registration_url
    # end
  end
end
