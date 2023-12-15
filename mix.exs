defmodule Viex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :viex,
      version: "0.3.1",
      elixir: "~> 1.4",
      description: "Elixir package to validate European VAT numbers with the VIES service.",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.semaphore": :test
      ],

      # Documentation
      name: "Viex",
      source_url: "https://github.com/marceldegraaf/viex",
      homepage_url: "http://github.com/marceldegraaf/viex",
      docs: [main: "Viex", extras: ["README.md"]]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:floki, "~> 0.13"},
      {:exvcr, "~> 0.8", only: :test},
      {:excoveralls, "~> 0.5", only: :test},
      {:ex_doc, "~> 0.14", only: :dev},
      {:earmark, "~> 1.1", only: :dev},
      {:credo, "~> 0.5", only: [:dev, :test]}
    ]
  end

  defp package do
    [
      licenses: ["WTFPL"],
      maintainers: ["Marcel de Graaf <mail@marceldegraaf.net>"],
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      links: %{
        "GitHub" => "https://github.com/marceldegraaf/viex",
        "Documentation" => "https://hexdocs.pm/viex"
      }
    ]
  end
end
