defmodule Readly.Mixfile do
  use Mix.Project

  def project do
    [
      app: :readly,
      version: "0.1.0",
      elixir: "~> 1.3",
      description: "Readly is a simple module that allow you to create readonly datasource module easily.",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      package: [
        maintainers: ["igrs"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/igrs/readly"}
      ],
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.12", only: :dev},
      {:ecto,   "~> 1.1",  only: :test}
    ]
  end
end
