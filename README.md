# Readly
[![Build Status](https://travis-ci.org/igrs/readly.svg?branch=master)](https://travis-ci.org/igrs/readly)
[![hex.pm version](https://img.shields.io/hexpm/v/readly.svg)](https://hex.pm/packages/readly)

Readly is a simple module that allow you to create readonly datasource module easily.
it is inspired by [ActiveHash](https://github.com/zilkey/active_hash).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add readly to your list of dependencies in `mix.exs`:

        def deps do
          [{:readly, "~> 0.0.1"}]
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
```

## TODO

- [ ] Implement [Ecto]() type