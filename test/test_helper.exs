ExUnit.start(capture_log: true)

Code.require_file("./support/repos.exs", __DIR__)
Code.require_file("./support/schemas.exs", __DIR__)

alias BoltxEctoTest.Repo

defmodule BoltxEcto.TestHelper do
  def opts() do
    [
      hostname: "127.0.0.1",
      auth: [username: "neo4j", password: "boltxPassword"],
      user_agent: "boltxTest/1",
      ssl_opts: ssl_opts(),
      pool_size: 1,
      prefix: :default,
      scheme: "bolt",
      ssl: false
    ]
  end

  defp ssl_opts() do
    [versions: [:"tlsv1.2"]]
  end
end

{:ok, _pid} = Repo.start_link()
