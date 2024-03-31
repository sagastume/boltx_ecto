defmodule Boltx.Cypher do

  def update(schema_meta, fields, filters, options \\ []) do
    cql = """
    MATCH (p:Post {id: 123})
    SET p.contenido = 'Nuevo contenido',
        p.fecha = '2024-03-31'
    RETURN p
    """
    [
      "MATCH",
      "(",
      "node:",
      labels(schema_meta, options),
      filters(filters),
      ")",
      set(fields),
      "RETURN node"
    ]
  end

  defp filters(filters) do
    Enum.into(filters, %{})
  end

  defp set(fields) do
    fields
  end

  defp labels(schema_meta, options) do
    labels = schema_meta.schema.__node_labels__

    all_labels =
      case labels do
        [] -> [String.capitalize(schema_meta.source)]
        _ -> capitalize_labels(labels)
      end

    all_labels = Enum.concat(all_labels, options[:labels] || [])
    capitalize_labels(all_labels)
  end

  defp capitalize_labels(labels) do
    Enum.map(labels, &String.capitalize/1)
  end
end
