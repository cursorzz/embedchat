use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :embed_chat, EmbedChat.Endpoint,
  http: [port: {:system, "PORT"}],
  https: [port: 443,
          keyfile: System.get_env("SSL_KEY_PATH"),
          certfile: System.get_env("SSL_CERT_PATH"),
          cacertfile: System.get_env("SSL_INTERMEDIATE_CERT_PATH")],
  url: [host: System.get_env("HOST"), port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  server: true

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :embed_chat, EmbedChat.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :embed_chat, EmbedChat.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :embed_chat, EmbedChat.Endpoint, server: true
#
# You will also need to set the application root to `.` in order
# for the new static assets to be served after a hot upgrade:
#
#     config :embed_chat, EmbedChat.Endpoint, root: "."

# Finally import the config/prod.secret.exs
# which should be versioned separately.
import_config "prod.secret.exs"

memory_stats = ~w(atom binary ets processes total)a

config :exometer,
  predefined: [
    {
      ~w(erlang memory)a,
      {:function, :erlang, :memory, [], :proplist, memory_stats},
      []
    }
  ],
  report: [
    reporters: [
      {
        :exometer_report_statsd,
        [hostname: 'dogstatsd', port: 8125]
      }
    ],
    subscribers: [
      {
        :exometer_report_statsd,
        [:erlang, :memory], memory_stats, 1_000, true
      }
    ]
  ]

config :elixometer,
  reporter: :exometer_report_statsd,
  env: Mix.env,
  metric_prefix: "embed_chat"

config :embed_chat, EmbedChat.Repo,
  loggers: [{Ecto.LogEntry, :log, []}, {EmbedChat.Repo.Metrics, :record_metric, []}]
