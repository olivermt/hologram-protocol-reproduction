defmodule HologramSkeleton.Types.TempoDuration do
  use Ash.Type

  @impl true
  def storage_type(_constraints), do: :duration

  @impl true
  def cast_input(nil, _constraints), do: {:ok, nil}
  def cast_input(%Tempo.Duration{} = duration, _constraints), do: normalize(duration)

  def cast_input(value, constraints) when is_binary(value) do
    case Tempo.from_iso8601(String.trim(value)) do
      {:ok, %Tempo.Duration{} = duration} -> cast_input(duration, constraints)
      {:ok, _value} -> {:error, message: "must be an ISO 8601 duration"}
      {:error, reason} -> {:error, message: Exception.message(reason)}
    end
  end

  def cast_input(_value, _constraints), do: :error

  @impl true
  def cast_stored(nil, _constraints), do: {:ok, nil}
  def cast_stored(%Duration{} = duration, _constraints), do: normalize(duration)
  def cast_stored(value, constraints) when is_binary(value), do: cast_input(value, constraints)
  def cast_stored(_value, _constraints), do: :error

  @impl true
  def dump_to_native(nil, _constraints), do: {:ok, nil}

  def dump_to_native(%Tempo.Duration{} = duration, _constraints) do
    Tempo.to_elixir(duration)
  end

  def dump_to_native(_value, _constraints), do: :error

  @impl true
  def dump_to_embedded(nil, _constraints), do: {:ok, nil}

  def dump_to_embedded(%Tempo.Duration{} = duration, _constraints) do
    {:ok, Tempo.to_iso8601(duration)}
  end

  def dump_to_embedded(_value, _constraints), do: :error

  @impl true
  def matches_type?(%Tempo.Duration{}, _constraints), do: true
  def matches_type?(_value, _constraints), do: false

  @impl true
  def cast_atomic(value, constraints) do
    case cast_input(value, constraints) do
      {:ok, casted} -> {:atomic, casted}
      _error -> {:not_atomic, "Tempo durations require runtime parsing"}
    end
  end

  @impl true
  def generator(_constraints), do: StreamData.constant(Tempo.Duration.new!(minute: 30))

  defp normalize(%Tempo.Duration{} = duration) do
    with {:ok, native} <- Tempo.to_elixir(duration) do
      normalize(native)
    end
  end

  defp normalize(%Duration{} = duration) do
    duration =
      Duration.new!(
        month: duration.year * 12 + duration.month,
        day: duration.week * 7 + duration.day,
        second: duration.hour * 3600 + duration.minute * 60 + duration.second,
        microsecond: duration.microsecond
      )

    {:ok, Tempo.from_elixir(duration)}
  end
end
