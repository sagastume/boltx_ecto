defmodule BoltxEctoTest do
  @moduledoc false
  alias Boltx
  alias BoltxEctoTest.Repo
  alias BoltxEctoTest.Schemas.Post

  use ExUnit.Case

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
  end
end
