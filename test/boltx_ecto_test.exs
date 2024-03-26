defmodule ArangoXEctoTest do
  @moduledoc false
  alias Boltx
  alias BoltxEctoTest.Repo
  alias BoltxEctoTest.Schemas.Post

  use ExUnit.Case

  describe "Insert" do
    test "insert schema" do
      post = %Post{
        counter: 1,
        title: "Título del post",
        temp: "temp",
        public: true,
        cost: 10.5,
        visits: 100,
        intensity: 0.75,
        meta: %{key: "value"},
        posted: Date.utc_today()
      }

      assert {:ok, _} = Repo.insert(post)
    end
  end
end
