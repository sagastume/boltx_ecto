import Config

config :logger, level: :debug

config :ecto,
  log: true,
  log_hex: false

config :boltx_ecto,
  ecto_repos: [BoltxEctoTest.Repo]

config :boltx_ecto, BoltxEctoTest.Repo,
  uri: "bolt://localhost:7689",
  auth: [username: "neo4j", password: "boltxPassword"],
  user_agent: "boltxEctoTest/1",
  pool_size: 15,
  max_overflow: 3,
  versions: [4.4]
