defmodule MatrixTest do
  use ExUnit.Case, async: true

  doctest Matrix

  test "Matrix.to_list and Matrix.from_list" do
    list = Enum.to_list(1..:rand.uniform(1000))

    assert list = Matrix.from_list(list) |> Matrix.to_list()
  end

  test "Matrix.from_list and Matrix.to_list" do
    map = Enum.to_list(1..:rand.uniform(1000)) |> Matrix.from_list()
    
    assert map = Matrix.to_list(map) |> Matrix.from_list()
  end
end