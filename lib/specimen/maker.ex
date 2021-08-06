defmodule Specimen.Maker do
  @moduledoc false

  def make_one(module, factory, states) do
    module
    |> Specimen.new()
    |> generate(factory, 1, states)
    |> List.first()
  end

  def make_many(module, factory, count, states) do
    module
    |> Specimen.new()
    |> generate(factory, count, states)
  end

  defp generate(%Specimen{} = specimen, factory, count, states) do
    generator = fn ->
      specimen
      |> factory.build()
      |> apply_states(factory, states)
      |> Specimen.to_struct()
      |> factory.after_making()
    end

    generator
    |> Stream.repeatedly()
    |> Enum.take(count)
  end

  defp apply_states(specimen, factory, states) do
    Enum.reduce(states, specimen, fn state, specimen ->
      Specimen.transform(specimen, &apply(factory, :state, [state, &1]))
    end)
  end
end
