defmodule Matrix do
  @moduledoc """

    Documentation Matrix Module
    
  """

  @doc """
  
    Converts a multidimensional list into a zero-indexed map.
    
    ## Parameters
      - list: the list to convert.

    ## Example
      iex> Matrix.from_list([])
      %{}

      iex> Matrix.from_list(["x", "o", "x"])
      %{0 => "x", 1 => "o", 2 => "x"}

      iex> Matrix.from_list([["x", "o", "x"]])
      %{0 => %{0 => "x", 1 => "o", 2 => "x"}}

      iex> Matrix.from_list([["x", "o", "x"],
      ...>                   ["o", "x", "o"],
      ...>                   ["x", "o", "x"]])
      %{0 => %{0 => "x", 1 => "o", 2 => "x"},
        1 => %{0 => "o", 1 => "x", 2 => "o"},
        2 => %{0 => "x", 1 => "o", 2 => "x"}}
    
  """

  def from_list(list) when is_list(list) do
    do_from_list(list)
  end

  defp do_from_list(list, map \\ %{}, index \\ 0)
  defp do_from_list([], map, _index) do
    map
  end
  defp do_from_list([h | t], map, index) do
    map = Map.put(map, index, do_from_list(h))
    do_from_list(t, map, index+1)
  end
  defp do_from_list(other, _, _) do
    other
  end

  @doc """

    Converts a zero-indexed map into a multidimensional list.
  
    ## Parameters
      - matrix: the matrix to convert.
    
    ## Example
      iex> Matrix.to_list(%{})
      []
      
      iex> Matrix.to_list(%{0 => "x", 1 => "o", 2 => "x"})
      ["x", "o", "x"]

      iex> Matrix.to_list(%{0 => %{0 => "x", 1 => "o", 2 => "x"}})
      [["x", "o", "x"]]

      iex> Matrix.to_list(%{0 => %{0 => "x", 1 => "o", 2 => "x"},
      ...>                  1 => %{0 => "o", 1 => "x", 2 => "o"},
      ...>                  2 => %{0 => "x", 1 => "o", 2 => "x"}})
      [["x", "o", "x"],
       ["o", "x", "o"],
       ["x", "o", "x"]]
    
  """

  def to_list(matrix) when is_map(matrix) do
    do_to_list(matrix)
  end

  defp do_to_list(matrix) when is_map(matrix) do
    Map.values(matrix)
    |> Enum.map(fn matrix -> do_to_list(matrix) end)
  end
  defp do_to_list(other) do
    other
  end
end