class Players::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  VALID_DOMAINS = ["restorando.com"]

  def google_oauth2
    auth_details = request.env["omniauth.auth"]
    if auth_details.info['email'].split("@")[1].in? VALID_DOMAINS
      @player = Player.from_omniauth(auth_details)

      sign_in_and_redirect @player, event: :authentication
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      render text: "We're sorry, at this time we do not allow access to our app."
    end
  end
end
