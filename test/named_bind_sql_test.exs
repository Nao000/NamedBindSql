defmodule NamedBindSqlTest do
  use ExUnit.Case
  test "integrate prepare_sql_with_params" do
    sql = "SELECT * FROM table1 AS t1 WHERE t1.id = :id AND t1.created_at = :created_at AND t1.id = :id;"

    bind_map = %{":id" => 1000, ":created_at" => "2021-02-28 00:00:00"}

    assert NamedBindSql.prepare_sql_with_params(sql, bind_map) ==
      {
        "SELECT * FROM table1 AS t1 WHERE t1.id = $1 AND t1.created_at = $2 AND t1.id = $1 ;",
        [1000, "2021-02-28 00:00:00"]
      }
  end
end
