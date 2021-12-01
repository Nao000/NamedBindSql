# NamedBindSql

## summary

I want to use named params in Elixir `Ecto.Adapters.SQL.Query` so I try make this.

## example

1. prepare sql with named params.
   * `sql = "SELECT * FROM table1 AS t1 WHERE t1.id = :id AND t1.created_at = :created_at AND t1.id = :id;"`
1. prepare params map
   * `params = %{"id" => 1000, "created_at" => "2021-02-28 00:00:00"}`
1. execute
   * `{sql_doller, param_list} = NamedBindSql.prepare_sql_with_params(sql, params)`
1. result
    ```elixir
    {
      "SELECT * FROM table1 AS t1 WHERE t1.id = $1 AND t1.created_at = $2 AND t1.id = $1 ;",
      [1000, "2021-02-28 00:00:00"]
    }
    ```
1. use in `Ecto.Adapters.SQL.Query`
    ```elixir
    {sql_doller, param_list} = NamedBindSql.prepare_sql_with_params(sql, params)

    Ecto.Adapters.SQL.Query(Yourapp.Repo, sql_doller, param_list)
    ```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `named_bind_sql` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:named_bind_sql, "~> 0.1.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/named_bind_sql/](https://hexdocs.pm/named_bind_sql/).