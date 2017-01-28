defmodule Viex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :viex,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),

      # Documentation
      name: "Viex",
      source_url: "https://github.com/marceldegraaf/viex",
      homepage_url: "http://github.com/marceldegraaf/viex",
      docs: [main: "Viex", extras: ["README.md"]]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Viex.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.11"},
      {:floki, "~> 0.13"},
      {:ex_doc, "~> 0.14", only: :dev},
      {:earmark, "~> 1.1", only: :dev}
    ]
  end
end