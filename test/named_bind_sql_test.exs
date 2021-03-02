defmodule NamedBindSqlTest do
  use ExUnit.Case

  test "get only `:word`" do
    only_colon_word =
      "SELECT * FROM table1 AS t1 WHERE t1.id = :id AND t1.created_at = :created_at AND t1.id = :id;"
      |> NamedBindSql.only_colon_word()

    assert only_colon_word == [":id", ":created_at", ":id"]
  end

  test "remove duplicate colon word" do
    remove_duplicate_colon_word =
    [":id", ":created_at", ":id"]
    |> NamedBindSql.remove_duplicate_colon_word()

    assert remove_duplicate_colon_word == [":id", ":created_at"]
  end

  test "list to ordered map" do
    list_to_ordered_map =
      [":id", ":created_at"]
      |> NamedBindSql.list_to_ordered_map()

    assert list_to_ordered_map == %{":id" => "$1", ":created_at" => "$2"}
  end

  test "replace with map" do
    string = "SELECT * FROM table1 AS t1 WHERE t1.id = :id AND t1.created_at = :created_at AND t1.id = :id;"

    map = %{":id" => "$1", ":created_at" => "$2"}

    assert NamedBindSql.replace_with_map(string, map) == "SELECT * FROM table1 AS t1 WHERE t1.id = $1 AND t1.created_at = $2 AND t1.id = $1 ;"
  end

  test "replace with map within new line" do
    string = "SELECT * FROM table1 AS t1\n"
    <> "WHERE 1 = 1\n"
    <> "AND t1.id = :id\n"
    <> "AND t1.created_at = :created_at \n"
    <> "AND t1.id = :id;"

    map = %{":id" => "$1", ":created_at" => "$2"}

    assert NamedBindSql.replace_with_map(string, map) == "SELECT * FROM table1 AS t1 \n"
    <> "WHERE 1 = 1 \n"
    <> "AND t1.id = $1 \n"
    <> "AND t1.created_at = $2  \n"
    <> "AND t1.id = $1 ;"
  end

  test "prepare bind list" do
    prepare_list = [":id", ":created_at"]

    bind_map = %{":id" => 1000, ":created_at" => "2021-02-28 00:00:00"}

    assert NamedBindSql.prepare_bind_list(prepare_list, bind_map) == [1000, "2021-02-28 00:00:00"]
  end

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
