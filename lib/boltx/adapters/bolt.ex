defmodule Boltx.Adapters.Bolt do
  @moduledoc false

  @otp_app :boltx_ecto

  @behaviour Ecto.Adapter

  @impl Ecto.Adapter
  defmacro __before_compile__(_env) do
    :ok
  end

  @impl Ecto.Adapter
  def init(config) do
    child = Boltx.child_spec(config)

    # Maybe something here later
    meta = %{}

    {:ok, child, meta}
  end

  @doc false
  @impl Ecto.Adapter
  def checked_out?(_adapter_meta) do
    false
  end

  @impl Ecto.Adapter
  def checkout(_adapter_meta, _opts, _callback) do
    raise "#{inspect(__MODULE__)}.checkout: #{inspect(__MODULE__)} does not currently support checkout"
  end

  @impl Ecto.Adapter
  def ensure_all_started(config, type) do
    {:ok, _} = Application.ensure_all_started(@otp_app, type)

    {:ok, [config]}
  end

  @impl Ecto.Adapter
  def dumpers(:binary_id, type), do: [type, Ecto.UUID]
  def dumpers(_primitive, type), do: [type]

  @impl Ecto.Adapter
  def loaders(:binary_id, type), do: [Ecto.UUID, type]
  def loaders(_primitive, type), do: [type]
end
