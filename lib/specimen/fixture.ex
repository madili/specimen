defmodule Specimen.Fixture do
  @moduledoc """
  Generates fixtures for Elixir basic types.
  """

  @integer_threshold 60_000_000
  @binary_threshold 10

  defguard is_postive_integer(value) when is_integer(value) and value > 0

  def make(:integer) do
    :crypto.rand_uniform(-@integer_threshold, @integer_threshold)
  end

  def make(:string) do
    UUID.uuid4(:hex)
  end

  def make(:binary) do
    :crypto.strong_rand_bytes(@binary_threshold)
  end

  def make(:float) do
    :rand.uniform()
  end

  def make(:boolean) do
    Enum.random([true, false])
  end

  def make(:date_time) do
    DateTime.add(DateTime.utc_now(), make(:integer))
  end

  def make(:time) do
    DateTime.to_time(make(:date_time))
  end

  def make(:naive_date_time) do
    DateTime.to_naive(make(:date_time))
  end

  def make(type) do
    raise "Unsupported type #{type}"
  end

  def make_many(type, count)
      when is_atom(type)
      when is_postive_integer(count) do
    generator = fn -> make(type) end

    generator
    |> Stream.repeatedly()
    |> Enum.take(count)
  end
end
