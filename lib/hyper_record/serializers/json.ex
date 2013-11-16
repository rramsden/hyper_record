defmodule HyperRecord.Serializers.JSON do
  defmacro __using__(_) do
    quote do
      @doc """
      Convert an Ecto.Entity record to JSON
      """
      def to_json(entity) do
        mod = __MODULE__
        attr_readable = mod.attr_readable

        {module, _} = Code.eval_string("#{mod}.Entity")
        fields = entity.__record__(:fields)
        fields = Enum.filter Keyword.keys(fields), fn(key) ->
          module.__entity__(:field_type, key) != nil
            and Enum.member?(attr_readable, key)
        end
        data = Enum.map fields, fn(key) -> {key, to_string(apply(entity, key, []))} end
        {:ok, json} = JSEX.encode(data)
        json
      end
    end
  end
end
