defmodule BoltxEctoTest do
  @moduledoc false
  alias Boltx
  alias BoltxEctoTest.Repo
  alias BoltxEctoTest.Schemas.{Post, Pet}

  use ExUnit.Case

  defmodule MySchemaLabels do
    use Boltx.Schema

    schema "my_schema_labels" do
      field(:name, :string)

      labels(["Person", "employee", "manager"])
    end
  end

  describe "Insert" do
    test "simple insert schema" do
      post = %Post{
        counter: 1,
        title: "Título del post",
        temp: "temp",
        public: true,
        visits: 100,
        intensity: 0.75,
        posted: Date.utc_today()
      }

      assert {:ok, response} = Repo.insert(post)
      assert {:ok, _} = Ecto.UUID.cast(response.id)
    end

    test "insert with custom primary key name" do
      pet = %Pet{
        name: "KOTOMI"
      }

      assert {:ok, response} = Repo.insert(pet)
      assert {:ok, _} = Ecto.UUID.cast(response.uuid)
    end

    test "insert schema with multiple labels" do
      person = %MySchemaLabels{
        name: "Roberto J. Ball"
      }

      assert {:ok, response} = Repo.insert(person)
      assert {:ok, _} = Ecto.UUID.cast(response.id)
    end
  end
end
