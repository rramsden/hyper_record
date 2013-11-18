defmodule HyperRecord do
  defmacro attr_readable(keylist) do
    quote do
      def attr_readable do
        unquote(keylist) ++ [:id]
      end
    end
  end

  defmacro attr_accessible(keylist) do
    quote do
      def attr_accessible do
        unquote(keylist)
      end

      def attr_readable do
        unquote(keylist) ++ [:id]
      end
    end
  end

  defmacro __using__(opts) do
    quote do
      use Ecto.Model
      import Ecto.Query
      import unquote(__MODULE__)

      use HyperRecord.Serializers.JSON

      def find(id) do
        id = if is_integer(id) do
          id
        else
          {id, _} = Integer.parse(id); id
        end
        unquote(opts[:repo]).get(__MODULE__, id)
      end

      def update(entity, params) do
        key = get_key(entity)
        params = filter_keylist(params, __MODULE__.attr_accessible)

        entity = entity.update(params)
        unquote(opts[:repo]).update(entity)
        entity
      end

      def exists?(field, value) do
        table = to_string(unquote(__CALLER__.module))
        |> String.slice(7..-1)
        |> String.downcase

        value = case is_integer(value) do
          true -> value
          false -> "'#{value}'"
        end

        query = "SELECT id FROM #{table}s WHERE #{field} = #{value}"
        result = Ecto.Adapters.Postgres.query(unquote(opts[:repo]), query)
        result.num_rows > 0
      end

      def create, do: create([])
      def create(nil), do: create([])
      def create(params) do
        entity = __MODULE__.new(params)
        entity = entity.update(created_at: HyperRecord.DateTime.utc)
        entity = case function_exported?(__MODULE__, :before_create, 1) do
          true -> __MODULE__.before_create(entity)
          false -> entity
        end

        case __MODULE__.validate(entity) do
          [] ->
            {:ok, unquote(opts[:repo]).create(entity)}
          errors ->
            errors
        end
      end

      def destroy(entity) do
        unquote(opts[:repo]).delete(entity)
      end

      defp filter_keylist(keylist, list) do
        Enum.filter keylist, fn({key, value}) -> not key in list end
      end

      defp get_key(entity) do
        elem(entity, 1)
        |> to_string
        |> String.slice(7..-1)
        |> String.downcase
        |> binary_to_atom
      end
    end
  end
end
