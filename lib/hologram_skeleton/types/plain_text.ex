defmodule HologramSkeleton.Types.PlainText do
  use Ash.Type

  @impl Ash.Type
  def storage_type(_constraints), do: :string

  @impl Ash.Type
  def cast_input(value, _constraints) when is_binary(value), do: {:ok, value}
  def cast_input(_value, _constraints), do: :error

  @impl Ash.Type
  def cast_stored(value, constraints), do: cast_input(value, constraints)

  @impl Ash.Type
  def dump_to_native(value, constraints), do: cast_input(value, constraints)

  @impl Ash.Type
  def matches_type?(value, _constraints), do: is_binary(value)
end
