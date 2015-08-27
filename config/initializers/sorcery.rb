Rails.application.config.sorcery.submodules = [:external]

Rails.application.config.sorcery.configure do |config|
  config.external_providers = [:google]

# add this file to .gitignore BEFORE putting any secret keys in here

  config.google.key = "785970535978-q8udej076h8mmc0soc8ltskfk9am8s6d.apps.googleusercontent.com"
  config.google.secret = "xCVLDtR6--J35VZoXdXR7_wq"
  config.google.callback_url = "http://localhost:3000/oauth/callback?provider=google"
  config.google.user_info_mapping = {
    :email => "email",
    :first_name => "name",
    :provider => "google"
  }

  config.user_config do |user|

    user.authentications_class = Authentication

  end
  config.user_class = "Player"
end
