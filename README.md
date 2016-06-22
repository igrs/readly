# Readly
[![Build Status](https://travis-ci.org/igrs/readly.svg?branch=master)](https://travis-ci.org/igrs/readly)
[![hex.pm version](https://img.shields.io/hexpm/v/readly.svg)](https://hex.pm/packages/readly)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

Readly is a simple module that allow you to create readonly datasource module easily.
it is inspired by [ActiveHash](https://github.com/zilkey/active_hash).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add readly to your list of dependencies in `mix.exs`:

        def deps do
          [{:readly, "~> 0.0.2"}]
        end

  2. Ensure readly is started before your application:

        def application do
          [applications: [:readly]]
        end

## Example
```elixir
defmodule Gender do
  # Use with struct
  use Readly, struct: %{id: nil, name: ""}

  # First arg is datasource. (id is required)
  # Second arg is a function name.(both Atom and String are OK)
  readonly %{id: 1, name: "Man"}, "man"
  readonly %{id: 2, name: "Woman"}, :woman
  readonly %{id: 3, name: "Trans"}, :trans
end

Gender.man     # %Gender{id: 1, name: "Man"}
Gender.woman   # %Gender{id: 2, name: "Woman"}
Gender.trans   # %Gender{id: 3, name: "Trans"}
Gender.all     # [%Gender{id: 1, name: "Man"}, %Gender{id: 2, name: "Woman"}, %Gender{id: 3, name: "Trans"}]
Gender.reverse # [%Gender{id: 3, name: "Trans"}, %Gender{id: 2, name: "Woman"}, %Gender{id: 1, name: "Man"}]
Gender.get(1)  # %Gender{id: 1, name: "Man"}
Gender.options(:name, :id)  # [{"Man", 1}, {"Woman", 2} ,{"Trans", 3}]
```

with Ecto

```elixir
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
```

NOTICE: Readly not use Ecto.Type behavior just implement function (type cast load dump)

## TODO

- [x] Implement [Ecto](https://github.com/elixir-ecto/ecto) type
- [ ] Ensure id and function name are unique
