defmodule Readly do
  defmacro __using__([struct: struct]) do
    quote do
      import Readly, only: [read_only: 2]

      defstruct Enum.map(unquote(struct), &(&1))
    end
  end

  defmacro read_only(item, field) do
    func_name = cond do
      is_bitstring(field) -> String.to_atom(field)
      is_atom(field) -> field
      true -> nil
    end
    if func_name do
      quote do
        def unquote(field)() do
          struct(__MODULE__, unquote(item))
        end
      end
    end
  end
end

#defmodule ReTest do
#  use Readly, struct: %{en: "",  ja: "",   id: nil}
#
#  read_only %{en: "english",  ja: "英語",   id: 1}, :english
#end
