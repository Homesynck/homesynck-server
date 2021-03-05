use Mix.Config

# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
config :homesynck, HomesynckWeb.Endpoint,
  load_from_system_env: true,
  url: [host: Application.get_env(:homesynck, :app_hostname), port: Application.get_env(:homesynck, :app_port)],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Which server to start per endpoint:
#
config :homesynck, HomesynckWeb.Endpoint, server: true
