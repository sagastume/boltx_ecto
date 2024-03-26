defmodule BoltxEctoTest.Repo do
  use Ecto.Repo,
    otp_app: :boltx_ecto,
    adapter: Boltx.Adapters.Bolt
end
