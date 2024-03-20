defmodule Boltx.Adapters.BoltTest do
  use ExUnit.Case
  alias Boltx.Adapters.Bolt

  describe "Ecto.Adapter" do
    test "checked_out? returns true when connection is checked out" do
      adapter_meta = %{pid: self()}
      assert Bolt.checked_out?(adapter_meta)
    end

    test "checked_out? returns false when connection is not checked out" do
      adapter_meta = %{pid: nil}
      refute Bolt.checked_out?(adapter_meta)
    end
  end
end
