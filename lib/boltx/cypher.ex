defmodule Boltx.Cypher do
  @moduledoc false

  def match(), do: "MATCH"

  def match(labels) when is_list(labels) do
    "MATCH (:#{labels_clause(labels)})"
  end

  def match(labels, alias_node) when is_list(labels) do
    "MATCH (#{alias_node}:#{labels_clause(labels)})"
  end

  def match(labels, alias_node, filters) when is_list(labels) do
    {"MATCH (#{alias_node}:#{labels_clause(labels)} $filters)", %{filters: filters}}
  end

  defp labels_clause(labels) when is_list(labels) do
    labels = Enum.map(labels, &String.capitalize/1)
    Enum.join(labels, ":")
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
