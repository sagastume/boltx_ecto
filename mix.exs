defmodule BoltxEcto.MixProject do
  use Mix.Project

  @version "0.0.0"
  @url_github "https://github.com/sagastume/boltx_ecto"

  def project do
    [
      app: :boltx_ecto,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "Boltx Ecto",
      description: "Neo4j adapters for Ecto",
      docs: docs(),
      test_coverage: [
        tool: ExCoveralls,
        summary: [
          threshold: 90
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    %{
      files: [
        "lib",
        "mix.exs",
        "LICENSE"
      ],
      licenses: ["Apache 2.0"],
      maintainers: [
        "Luis Sagastume"
      ],
      links: %{
        "Docs" => "",
        "Github" => @url_github
      }
    }
  end

  defp docs() do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: ["README.md"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:boltx, "~> 0.0.6"},

      # Testing dependencies
      {:excoveralls, "~> 0.18.0", optional: true, only: [:test, :dev]},

      # Linting dependencies
      {:credo, "~> 1.7.3", only: [:dev]},
      {:dialyxir, "~> 1.4.3", only: [:dev], runtime: false},

      # Documentation dependencies
      # Run me like this: `mix docs`
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end
end
