defmodule Specimen.Maker do
  @moduledoc false

  def make_one(module, factory, states) do
    module
    |> Specimen.new()
    |> factory.build()
    |> make(factory, 1, states)
    |> List.first()
  end

  def make_many(module, factory, count, states) do
    module
    |> Specimen.new()
    |> factory.build()
    |> make(factory, count, states)
  end

  defp make(%Specimen{} = specimen, factory, count, states) do
    generator = fn -> apply_states(specimen, factory, states) end

    generator
    |> Stream.repeatedly()
    |> Stream.map(&Specimen.to_struct/1)
    |> Stream.map(&factory.after_making/1)
    |> Enum.take(count)
  end

  defp apply_states(specimen, factory, states) do
    Enum.reduce(states, specimen, fn state, specimen ->
      Specimen.include(specimen, &apply(factory, :state, [state, &1]))
    end)
  end
end
