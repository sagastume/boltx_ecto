defmodule Boltx.Cypher do
  def update(schema_meta, fields, filters, options \\ []) do
    labels = labels(schema_meta, options)
    filter_conditions = filters_conditions(filters)
    set_fields = set_fields(fields)

    cql = """
    MATCH (p:#{labels} #{filter_conditions})
    SET #{set_fields}
    RETURN p
    """
    cql
  end

  defp filters_conditions(filters) do
    IO.inspect(filters)
    "WHERE " <> Enum.map(filters, fn {key, value} -> "#{key} = '#{value}'" end) |> Enum.join(" AND ")
  end

  defp set_fields(fields) do
    Enum.map(fields, fn {key, value} -> "p.#{key} = '#{value}'" end) |> Enum.join(",\n        ")
  end

  defp labels(schema_meta, options) do
    labels = schema_meta.schema.__node_labels__

    all_labels =
      case labels do
        [] -> String.capitalize(schema_meta.source)
        _ -> capitalize_labels(labels)
      end

    all_labels = Enum.concat([all_labels], options[:labels] || [])
    Enum.join(all_labels, ":")
  end

  defp capitalize_labels(labels) do
    Enum.map(labels, &String.capitalize/1)
  end
end
