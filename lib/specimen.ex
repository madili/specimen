defmodule Specimen do
  @moduledoc """
  Documentation for `Specimen`.
  """

  @integer_threshold 60_000_000
  @binary_threshold 10

  def create(:integer) do
    :crypto.rand_uniform(-@integer_threshold, @integer_threshold)
  end

  def create(:string) do
    UUID.uuid4(:hex)
  end

  def create(:binary) do
    :crypto.strong_rand_bytes(@binary_threshold)
  end

  def create(:float) do
    :rand.uniform()
  end

  def create(:boolean) do
    Enum.random([true, false])
  end

  def create(:date_time) do
    DateTime.add(DateTime.utc_now(), create(:integer))
  end

  def create(:time) do
    DateTime.to_time(create(:date_time))
  end

  def create(:naive_date_time) do
    DateTime.to_naive(create(:date_time))
  end

  def create(:id) do
    System.unique_integer([:positive, :monotonic])
  end

  def create(:binary_id) do
    UUID.string_to_binary!(UUID.uuid4(:hex))
  end

  def create_many(type, number)
      when is_atom(type)
      when is_integer(number) and number > 0 do
    generator = fn -> create(type) end

    generator
    |> Stream.repeatedly()
    |> Enum.take(number)
  end
end
