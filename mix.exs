defmodule ExFieldDoc.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_field_doc,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [ ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.18"}
    ]
  end
end
