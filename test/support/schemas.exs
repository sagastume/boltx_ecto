defmodule BoltxEctoTest.Schemas.Post do
  use Boltx.Schema

  schema "post" do
    # Same as integer
    field(:counter, :id)
    field(:title, :string)
    field(:blob, :binary)
    field(:temp, :string, default: "temp", virtual: true)
    field(:public, :boolean, default: true)
    field(:visits, :integer)
    field(:intensity, :float)
    field(:bid, :binary_id)
    field(:links, {:map, :string})
    field(:intensities, {:map, :float})
    field(:posted, :date)
  end
end

defmodule BoltxEctoTest.Schemas.Pet do
  use Boltx.Schema

  # custom primary key
  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "Pet" do
    field(:name, :string)
  end
end
