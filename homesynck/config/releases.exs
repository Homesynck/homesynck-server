import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
app_port = System.fetch_env!("APP_PORT")
app_hostname = System.fetch_env!("APP_HOSTNAME")
db_user = System.fetch_env!("DB_USER")
db_password = System.fetch_env!("DB_PASSWORD")
db_host = System.fetch_env!("DB_HOST")
db_port = System.fetch_env!("DB_PORT")

config :homesynck, HomesynckWeb.Endpoint,
  http: [:inet6, port: String.to_integer(app_port)],
  secret_key_base: secret_key_base

config :homesynck,
  app_port: app_port

config :homesynck,
  app_hostname: app_hostname

# Configure your database
config :homesynck, Homesynck.Repo,
  username: db_user,
  password: db_password,
  database: "demo_prod",
  hostname: db_host,
  port: db_port,
  pool_size: 10
