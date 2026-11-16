defmodule Four.Board do
  @moduledoc """
  Pure four-in-a-row rules. No processes, no PubSub, no time: just data in, data out.

  The board is 7 columns × 6 rows. Each column is a list of colors from the bottom up,
  so dropping a piece is "append to that column".
  """
  @cols 7
  @rows 6

  defstruct columns: List.duplicate([], @cols), turn: :red, winner: nil, last: nil

  @type color :: :red | :yellow
  @type t :: %__MODULE__{}

  def new, do: %__MODULE__{}

  @doc "Drop `color` into column `col` (0..6). Returns {:ok, board} or {:error, reason}."
  def drop(%__MODULE__{winner: w}, _color, _col) when not is_nil(w), do: {:error, :game_over}
  def drop(%__MODULE__{turn: turn}, color, _col) when turn != color, do: {:error, :not_your_turn}
  def drop(_board, _color, col) when not is_integer(col) or col < 0 or col >= @cols,
    do: {:error, :no_such_column}

  def drop(board, color, col) do
    column = Enum.at(board.columns, col)

    if length(column) >= @rows do
      {:error, :column_full}
    else
      row = length(column)
      board = %{board | columns: List.replace_at(board.columns, col, column ++ [color]), last: {col, row}}
      {:ok, %{board | winner: winner(board, col, row, color), turn: other(color)}}
    end
  end

  @doc "The color at column `col`, row `row` (0 = bottom), or nil."
  def at(board, col, row) when col >= 0 and col < @cols and row >= 0,
    do: Enum.at(Enum.at(board.columns, col), row)

  def at(_board, _col, _row), do: nil

  @doc "JSON-safe map for the wire: strings, lists, maps only (no tuples, no structs)."
  def to_map(board) do
    %{
      columns: board.columns,
      turn: board.turn,
      winner: board.winner,
      last: if(board.last, do: Tuple.to_list(board.last))
    }
  end

  def other(:red), do: :yellow
  def other(:yellow), do: :red

  # --- private -------------------------------------------------------------

  @directions [{1, 0}, {0, 1}, {1, 1}, {1, -1}]

  defp winner(board, col, row, color) do
    cond do
      Enum.any?(@directions, fn dir -> line_length(board, col, row, color, dir) >= 4 end) -> color
      Enum.all?(board.columns, &(length(&1) == @rows)) -> :draw
      true -> nil
    end
  end

  # pieces in a line through (col,row): count both ways, plus the piece itself
  defp line_length(board, col, row, color, {dc, dr}) do
    1 + count(board, col + dc, row + dr, color, {dc, dr}) +
      count(board, col - dc, row - dr, color, {-dc, -dr})
  end

  defp count(board, col, row, color, {dc, dr} = dir) do
    if at(board, col, row) == color, do: 1 + count(board, col + dc, row + dr, color, dir), else: 0
  end
end
