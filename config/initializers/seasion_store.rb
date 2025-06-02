# config/initializers/session_store.rb

Rails.application.config.session_store :cookie_store,
  key: '_crm_app_session',
  secure: Rails.env.production?,  # Cookie only sent over HTTPS in production
  httponly: true,                 # Prevent JavaScript access to cookies
  same_site: :strict              # Restrict cookies to same-site requests (CSRF protection)
