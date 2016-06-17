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
  
  use with ecto

      defmodule User do
        use Ecto.Schema
        import Ecto.Changeset

        schema "users" do
          field :name, :string
          field :gender, Gender
        end

        def changeset(user, params \\ :invalid) do
          user
          |> cast(params, ~w(name gender), ~w())
        end
      end

      user = Repo.one(User)
      user.gender == Gender.woman

  ## summary

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

      def get(id) when is_integer(id) do
        list
        |> Enum.find(&(&1.id == id))
      end
      def get(_), do: nil

      defp list do
        @readley_datasource
        |> Enum.map(fn source -> struct(unquote(env.module), source) end)
      end

      # Ecto.Type imple
      def type, do: :integer

      def cast(integer) when is_integer(integer), do: do_get(integer)
      def cast(string) when is_bitstring(string) do
        case Integer.parse(string) do
          {integer, _} -> do_get(integer)
          _ -> :error
        end
      end
      def cast(%__MODULE__{} = datasource), do: {:ok, datasource}
      def cast(_), do: :error

      defp do_get(integer) do
        case get(integer) do
          %__MODULE__{} = datasource -> {:ok, datasource}
          _ -> :error
        end
      end

      def load(integer) when is_integer(integer) do
        case get(integer) do
          %__MODULE__{} = datasource -> {:ok, datasource}
          _ -> :error
        end
      end
      def load(_), do: :error

      def dump(%__MODULE__{} = datasource), do: {:ok, datasource.id}
      def dump(_), do: :error
    end
  end
end
