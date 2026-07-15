defmodule HologramSkeleton.ServerValue do
  alias HologramSkeleton.Types.PlainText

  def load do
    {:ok, value} = PlainText.cast_input("Ash type control", [])
    value
  end
end
