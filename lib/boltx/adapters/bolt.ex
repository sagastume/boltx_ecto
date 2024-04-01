defmodule Boltx.Adapters.Bolt do
  @moduledoc false
  alias Boltx
  alias Boltx.Cypher

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
  def autogenerate(:binary_id), do: nil
  def autogenerate(:embed_id), do: Ecto.UUID.generate()

  @impl Ecto.Adapter.Schema
  def insert(adapter_meta, schema_meta, params, _on_conflict, returning, options) do
    labels = get_labels(schema_meta, options)
    cypher = create(labels) |> Enum.join("")

    key = primary_key!(schema_meta, returning)
    primary_key = maybe_generate_key(key, params)

    params =
      case List.keymember?(params, key, 0) do
        true -> List.keyreplace(params, key, 0, {key, primary_key})
        false -> [{key, primary_key} | params]
      end

    %{pid: conn} = adapter_meta

    case Boltx.query(conn, cypher, %{props: Enum.into(params, %{})}) do
      {:ok, response} ->
        {:ok, returning_fields(key, returning, response)}

      {:error, err} ->
        {:error, err}
    end
  end

  @impl Ecto.Adapter.Schema
  def update(adapter_meta, schema_meta, fields, filters, returning, options) do
    %{pid: conn} = adapter_meta
    key = primary_key!(schema_meta, returning)
    filters = List.keyreplace(filters, key, 0, {key, Ecto.UUID.cast!(filters[key])})
    cql = Cypher.update(schema_meta, fields, filters)

    IO.inspect(%{
      adapter_meta: adapter_meta,
      schema_meta: schema_meta,
      fields: fields,
      filters: filters,
      returning: returning,
      options: options,
      cql: cql,
      key: key
    }, label: "update")

    case Boltx.query(conn, cql, %{fields: fields}) do
      {:ok, response} ->
        {:ok, returning_fields(key, returning, response)}

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

  defp get_labels(schema_meta, options) do
    labels = schema_meta.schema.__node_labels__

    all_labels =
      case labels do
        [] -> [String.capitalize(schema_meta.source)]
        _ -> capitalize_labels(labels)
      end

    all_labels = Enum.concat(all_labels, options[:labels] || [])
    capitalize_labels(all_labels)
  end

  defp primary_key!(%{autogenerate_id: {_, key, _type}}, _), do: key
  defp primary_key!(schema_meta, []), do: hd(schema_meta.schema.__schema__(:primary_key))

  defp maybe_generate_key(key, params) do
    case List.keymember?(params, key, 0) do
      true -> Ecto.UUID.cast!(params[key])
      false -> Ecto.UUID.generate()
    end
  end

  defp capitalize_labels(labels) do
    Enum.map(labels, &String.capitalize/1)
  end

  defp returning_fields(key, returning, response) do
    properties = Boltx.Response.first(response)["node"].properties

    Enum.map(returning, fn field ->
      case field do
        ^key -> {field, Ecto.UUID.dump!(Map.get(properties, Atom.to_string(field)))}
        _ -> {field, Map.get(properties, Atom.to_string(field))}
      end
    end)
  end
end
