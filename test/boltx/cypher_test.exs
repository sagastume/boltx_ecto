defmodule Boltx.CypherTest do
  use ExUnit.Case

  alias Boltx.Cypher

  describe "MATCH" do
    test "without labels" do
      assert "MATCH" == Cypher.match()
    end

    test "Using label" do
      assert "MATCH (:Movie)" == Cypher.match(["Movie"])
    end

    test "Using labels" do
      assert "MATCH (:Movie:Fiction)" == Cypher.match(["Movie", "Fiction"])
    end

    test "Using labels with alias" do
      assert "MATCH (post:Movie:Fiction)" == Cypher.match(["Movie", "Fiction"], "post")
    end

    test "Including Provided Filters" do
      filters = %{
        name: "Matrix"
      }

      assert {"MATCH (post:Movie:Fiction $filters)", %{filters: filters}} ==
               Cypher.match(["Movie", "Fiction"], "post", filters)
    end


  end
end
