defmodule Nifty.Mixfile do
  use Mix.Project

  def project do
    [app: :nifty,
     version: "0.0.2",
     description: description,
     elixir: "~> 1.0",
     name: "Nifty",
     source_url: "https://github.com/rossjones/nifty",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     contributors: ["Ross Jones"],
     licenses: ["MIT"],
     links: %{
       github: "https://github.com/rossjones/nifty",
     }]
  end

  def application do
    [applications: [:logger]]
  end

  def description do
    """
    A semi-useful tool to generate boilerplate when you want to
    use a NIF in your project. You don't really want to use a NIF
    in your project, until you do. Then this might save you writing
    most of the boilerplate.

          mix nifty.gen --library hello --module MyApp.NIF
    """
  end

  defp deps do
    []
  end
end
