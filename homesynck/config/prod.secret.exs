use Mix.Config

# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """

toBool = fn
  "true" -> true
  "false" -> false
end

config :homesynck,
  # Admin account is an account created on server start
  # Usefull if you plan to disable register and allow only 1 account
  enable_admin_account: toBool.(System.get_env("ENABLE_ADMIN_ACCOUNT")),
  admin_username: System.get_env("ADMIN_USERNAME"),
  admin_password: System.get_env("ADMIN_PASSWORD"),
  enable_register: toBool.(System.get_env("ENABLE_REGISTER")),
  # Phone validation can be disabled. If enabled you will need your own
  # phone validation API.
  # Compliant phone validation APIs must:
  #  - Accept POST on / with Json body:
  #     {
  #       "number": <user phone number>,
  #       "message": <generated register token>,
  #       "secret": <api key if required>
  #     }
  #  - Reply with code 200 if success and body = "0"
  #
  # Phone validation is a spam prevention feature that can be useful for
  # big audience apps.
  # If activated a register token will be sent to a phone number validation API.
  # This API is then meant to send the token to the phone owner through automated SMS.
  # Then, the user would use this token to register one account.
  # Phone numbers used to generate a register token will be on a cooldown and
  # won't be authorized to generate another register token for 30 days.
  enable_phone_validation: toBool.(System.get_env("ENABLE_PHONE_VALIDATION")),
  phone_validation_api_endpoint: System.get_env("PHONE_VALIDATION_API_ENDPOINT") || "",
  phone_validation_api_key: System.get_env("PHONE_VALIDATION_API_KEY") || ""

config :homesynck, Homesynck.Repo,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  database_url: System.get_env("DATABASE_URL"),
  show_sensitive_data_on_connection_error: true

# secret_key_base =
#   System.get_env("SECRET_KEY_BASE") ||
#     raise """
#     environment variable SECRET_KEY_BASE is missing.
#     You can generate one by calling: mix phx.gen.secret
#     """
# Comment out secret_key_base, we've added it to prod.exs:

config :homesynck, HomesynckWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "8080"),
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [host: System.get_env("HOST")],
  secret_key_base: System.get_env("SECRET_KEY_BASE")
