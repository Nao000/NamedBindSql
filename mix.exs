defmodule NamedBindSql.MixProject do
  use Mix.Project

  @description """
    This can use named params when you use Ecto.Adapters.SQL.Query.
  """

  def project do
    [
      app: :named_bind_sql,
      version: "0.2.0",
      elixir: "~> 1.9",
      name: "NamedBindSql",
      description: @description,
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp package do
    [ maintainers: ["nao000"],
      licenses: ["MIT"],
      links: %{ "Github" => "https://github.com/Nao000/NamedBindSql" }
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
