defmodule Boltx.Adapters.Bolt do
  @moduledoc false
  alias Boltx

  @otp_app :boltx_ecto

  @behaviour Ecto.Adapter
  @behaviour Ecto.Adapter.Schema

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

  @impl Ecto.Adapter.Schema
  def autogenerate(:id), do: nil
  def autogenerate(Ecto.UUID), do: Ecto.UUID.generate()
  def autogenerate(:binary_id), do: nil
  def autogenerate(:embed_id), do: Ecto.UUID.generate()

  @impl Ecto.Adapter.Schema
  def insert(adapter_meta, schema_meta, params, _on_conflict, returning, _options) do
    labels = get_labels(schema_meta)
    cypher = create(labels) |> Enum.join("")

    key = primary_key!(schema_meta, returning)
    uuid = List.keyfind(params, key, 0, Ecto.UUID.generate())
    params = [{key, uuid} | params]

    %{pid: conn} = adapter_meta

    case Boltx.query(conn, cypher, %{props: Enum.into(params, %{})}) do
      {:ok, response} ->
        {:ok,
         [
           {key,
            Ecto.UUID.dump!(
              Boltx.Response.first(response)["node"].properties[Atom.to_string(key)]
            )}
         ]}

      {:error, err} ->
        {:error, err}
    end
  end

  defp create(labels) do
    [
      "CREATE ",
      "(",
      "node:",
      Enum.join(labels, ":"),
      " $props",
      ") ",
      "RETURN node"
    ]
  end

  defp get_labels(schema_meta) do
    labels = schema_meta.schema.__node_labels__

    case labels do
      [] -> [String.capitalize(schema_meta.source)]
      _ -> capitalize_labels(labels)
    end
  end

  defp primary_key!(%{autogenerate_id: {_, key, _type}}, [key]), do: key

  defp capitalize_labels(labels) do
    Enum.map(labels, &String.capitalize/1)
  end
end
