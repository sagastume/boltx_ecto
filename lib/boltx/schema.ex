defmodule Boltx.Schema do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true, source: :id}
      @foreign_key_type :binary_id

      def __node_labels__, do: []

      defoverridable __node_labels__: 0
    end
  end

  defmacro labels(labels) do
    quote do
      def __node_labels__, do: unquote(labels)
    end
  end
end
