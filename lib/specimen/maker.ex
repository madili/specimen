defmodule Specimen.Maker do
  @moduledoc false

  @doc """
  Makes one item as specified by the factory.

  ## Options

  - `:states` - A list of states to be applied to the item.
  """
  def make_one(module, factory, opts \\ []) do
    {states, _opts} = Keyword.pop(opts, :states, [])

    module
    |> Specimen.new()
    |> generate(factory, 1, states)
    |> List.first()
  end

  @doc """
  Makes many items as specified by the factory.

  ## Options

  - `:states` - A list of states to be applied to the item.
  """
  def make_many(module, factory, count, opts \\ []) do
    {states, _opts} = Keyword.pop(opts, :states, [])

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
