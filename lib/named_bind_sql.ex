defmodule NamedBindSql do
  def prepare_sql_with_params(sql, bind_map) do
    remove_duplicate_colon_word = sql
    |> only_colon_word()
    |> remove_duplicate_colon_word()

    list_to_ordered_map = remove_duplicate_colon_word
    |> list_to_ordered_map()

    prepare_bind_list = remove_duplicate_colon_word
    |> prepare_bind_list(bind_map)

    {replace_with_map(sql, list_to_ordered_map), prepare_bind_list}
  end

  def only_colon_word(sql) do
    sql
    |> String.split([" ", ";"])
    |> Enum.filter(fn(x) -> String.at(x, 0) == ":" end)
  end

  def remove_duplicate_colon_word(colon_word_list) do
    colon_word_list |> Enum.uniq
  end

  def list_to_ordered_map(list) do
    _list_to_ordered_map(list, %{}, 1)
  end

  defp _list_to_ordered_map([], reduced, _number) do reduced end

  defp _list_to_ordered_map([first | rest ], reduced, number) do
    _list_to_ordered_map(rest, Map.put(reduced, first, "$" <> Integer.to_string(number)), number+1)
  end

  def replace_with_map(string, map) do
    string
    |> String.replace(";", " ;")
    |> String.split([" "])
    |> Enum.map_join(" ", fn word -> _replace_with_map(word, map) end)
  end

  defp _replace_with_map(word, map) do
    doller = Map.get(map, word)
    if doller, do: doller, else: word
  end

  def prepare_bind_list(prepare_list, bind_map) do
    prepare_list
    |> Enum.map(fn prepare_list -> Map.get(bind_map, prepare_list) end)
  end

end
