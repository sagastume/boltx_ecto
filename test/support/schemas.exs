defmodule BoltxEctoTest.Schemas.Post do
  use Ecto.Schema

  schema "schema" do
    # Same as integer
    field(:counter, :id)
    field(:title, :string)
    field(:blob, :binary)
    field(:temp, :string, default: "temp", virtual: true)
    field(:public, :boolean, default: true)
    field(:cost, :decimal)
    field(:visits, :integer)
    field(:intensity, :float)
    field(:bid, :binary_id)
    field(:meta, :map)
    field(:links, {:map, :string})
    field(:intensities, {:map, :float})
    field(:posted, :date)
  end
end
