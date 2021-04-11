defmodule NamedBindSql do
  @doc """
  ## example

      iex> sql = "SELECT * FROM table1 AS t1 WHERE t1.id = :id1 AND t1.id2 = :id2 AND t1.id = :id1;"
      "SELECT * FROM table1 AS t1 WHERE t1.id = :id1 AND t1.id2 = :id2 AND t1.id = :id1;"

      iex> params = %{":id1" => 1, ":id2" => 2}
      %{":id1" => 1, ":id2" => 2}

      iex> {sql_doller, param_list} = NamedBindSql.prepare_sql_with_params(sql, params)
      {
        "SELECT * FROM table1 AS t1 WHERE t1.id = $1 AND t1.id2 = $2 AND t1.id = $1 ;",
        [1, 2]
      }

  """
  def prepare_sql_with_params(sql, bind_map) do
    remove_duplicate_colon_word = sql
    |> _only_colon_word()
    |> _remove_duplicate_colon_word()

    list_to_ordered_map = remove_duplicate_colon_word
    |> _list_to_ordered_map()

    prepare_bind_list = remove_duplicate_colon_word
    |> _prepare_bind_list(bind_map)

    {replace_with_map(sql, list_to_ordered_map), prepare_bind_list}
  end

  defp _only_colon_word(sql) do
    sql
    |> String.split([" ", ";", "\n"])
    |> Enum.filter(fn(x) -> String.at(x, 0) == ":" end)
  end

  defp _remove_duplicate_colon_word(colon_word_list) do
    colon_word_list |> Enum.uniq
  end

  defp _list_to_ordered_map(list) do
    _list_to_ordered_map(list, %{}, 1)
  end

  defp _list_to_ordered_map([], reduced, _number) do reduced end

  defp _list_to_ordered_map([first | rest ], reduced, number) do
    _list_to_ordered_map(rest, Map.put(reduced, first, "$" <> Integer.to_string(number)), number+1)
  end

  defp replace_with_map(string, map) do
    string
    |> String.replace(";", " ;")
    |> String.replace("\n", " \n")
    |> String.split([" "])
    |> Enum.map_join(" ", fn word -> _replace_with_map(word, map) end)
  end

  defp _replace_with_map(word, map) do
    doller = Map.get(map, word)
    if doller, do: doller, else: word
  end

  defp _prepare_bind_list(prepare_list, bind_map) do
    prepare_list
    |> Enum.map(fn prepare_list -> Map.get(bind_map, prepare_list) end)
  end

end
