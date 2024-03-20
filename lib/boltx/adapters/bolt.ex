defmodule Boltx.Adapters.Bolt do
  @moduledoc false

  @behaviour Ecto.Adapter

  defmacro __before_compile__(_env) do
    :ok
  end

  @doc false
  def checked_out?(adapter_meta) do
    %{pid: pool} = adapter_meta
    get_conn(pool) != nil
  end

  defp get_conn(pool) do
    Process.get(__MODULE__, pool)
  end
end
