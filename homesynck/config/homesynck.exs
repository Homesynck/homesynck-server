use Mix.Config

config :homesynck,
  require_login_for_directories: System.get_env("ENABLE_USERS"),
  enable_registration: true,
  enable_phone_validation: true

config :homesynck, HomesynckWeb.Endpoint, serve_homesynck_presentation_site: true
