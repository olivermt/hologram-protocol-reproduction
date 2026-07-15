defmodule HologramSkeleton.ServerValue do
  alias HologramSkeleton.Types.TempoDuration

  def load do
    {:ok, duration} = TempoDuration.cast_input("PT30M", [])
    "Tempo duration #{Tempo.to_iso8601(duration)}"
  end
end
