defmodule Readly do
  @moduledoc ~S"""
  This is Readly module.

  ## Example
      defmodule Gender do
        use Readly, struct: %{id: nil, name: ""}

        readonly %{id: 1, name: "Man"}, "man"
        readonly %{id: 1, name: "Woman"}, :woman
        readonly %{id: 1, name: "Trans"}, :trans
      end
  """

  @doc false
  defmacro __using__([struct: struct]) do
    quote do
      import Readly, only: [readonly: 2]

      defstruct Enum.map(unquote(struct), &(&1))

      Module.register_attribute(__MODULE__, :readley_datasource, accumulate: true)

      @before_compile Readly
    end
  end

  @doc """
  define readonly macro
  - Put map to module attributes
  - Define specific function
  """
  defmacro readonly(item, function_name) do
    func_name = cond do
      is_bitstring(function_name) -> String.to_atom(function_name)
      is_atom(function_name) -> function_name
      true -> nil
    end

    if func_name do
      quote do
        Module.put_attribute(__MODULE__, :readley_datasource, unquote(item))
        def unquote(func_name)() do
          struct(__MODULE__, unquote(item))
        end
      end
    end
  end

  @doc false
  defmacro __before_compile__(env) do
    quote do
      def all do
        list
        |> Enum.sort(fn a, b -> a.id < b.id end)
      end

      def reverse, do: all |> Enum.reverse

      def get(nil), do: nil
      def get(id) do
        list
        |> Enum.find(&(&1.id == id))
      end

      defp list do
        @readley_datasource
        |> Enum.map(fn source -> struct(unquote(env.module), source) end)
      end
    end
  end
end
