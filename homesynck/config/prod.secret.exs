use Mix.Config

# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """

config :homesynck,
  enable_admin_account: true,
  admin_username: System.get_env("ADMIN_USERNAME"),
  admin_password: System.get_env("ADMIN_PASSWORD"),
  enable_register: true,
  enable_phone_validation: true,
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
