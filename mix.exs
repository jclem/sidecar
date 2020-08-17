defmodule Sidecar.MixProject do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :sidecar,
      description: "Run sidecar processes with Elixir apps",
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # Docs
      name: "Sidecar",
      source_url: "https://github.com/jclem/sidecar",
      homepage_url: "https://github.com/jclem/sidecar",
      docs: [
        main: "Sidecar",
        extras: ["README.md", "LICENSE.md"],
        source_ref: @version
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      files: ["lib", "portwrap.sh", ".formatter.exs", "mix.exs", "README.md", "LICENSE.md"],
      links: %{"GitHub" => "https://github.com/jclem/sidecar"}
    ]
  end
end
