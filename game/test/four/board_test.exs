defmodule Four.BoardTest do
  use ExUnit.Case, async: true
  alias Four.Board

  # play a list of columns, alternating red/yellow from the start
  defp play(cols) do
    Enum.reduce(cols, Board.new(), fn col, b ->
      {:ok, b} = Board.drop(b, b.turn, col)
      b
    end)
  end

  test "red moves first and pieces stack from the bottom" do
    b = play([3, 3])
    assert Board.at(b, 3, 0) == :red
    assert Board.at(b, 3, 1) == :yellow
    assert b.turn == :red
  end

  test "you cannot move out of turn" do
    assert Board.drop(Board.new(), :yellow, 0) == {:error, :not_your_turn}
  end

  test "a full column refuses another piece" do
    b = play([0, 0, 0, 0, 0, 0])
    assert Board.drop(b, :red, 0) == {:error, :column_full}
  end

  test "columns outside 0..6 are refused" do
    assert Board.drop(Board.new(), :red, 7) == {:error, :no_such_column}
    assert Board.drop(Board.new(), :red, -1) == {:error, :no_such_column}
  end

  test "four across wins" do
    assert play([0, 0, 1, 1, 2, 2, 3]).winner == :red
  end

  test "four up wins" do
    assert play([0, 1, 0, 1, 0, 1, 0]).winner == :red
  end

  test "four on a rising diagonal wins" do
    # red: (0,0) (1,1) (2,2) (3,3)
    assert play([0, 1, 1, 2, 3, 2, 2, 3, 3, 6, 3]).winner == :red
  end

  test "four on a falling diagonal wins" do
    # red: (3,0) (2,1) (1,2) (0,3)
    assert play([3, 2, 2, 1, 0, 1, 1, 0, 0, 6, 0]).winner == :red
  end

  test "no moves after the game is over" do
    b = play([0, 0, 1, 1, 2, 2, 3])
    assert Board.drop(b, b.turn, 5) == {:error, :game_over}
  end

  test "a full board with no four is a draw" do
    # columns filled in an order that never lines up four
    order = [0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0,
             2, 3, 2, 3, 2, 3, 3, 2, 3, 2, 3, 2,
             4, 5, 4, 5, 4, 5, 5, 4, 5, 4, 5, 4,
             6, 6, 6, 6, 6, 6]
    assert play(order).winner == :draw
  end

  test "to_map is JSON-safe" do
    b = play([3])
    assert Jason.encode!(Board.to_map(b)) =~ ~s("last":[3,0])
  end
end
