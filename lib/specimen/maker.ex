defmodule Specimen.Maker do
  @moduledoc false

  @doc """
  Makes one item as specified by the factory.

  ## Options

  - `:states` - A list of states to be applied to the item.
  - `:context` - A map or keyword list to act as a shared context.
  """
  def make_one(module, factory, opts \\ []) do
    {states, opts} = Keyword.pop(opts, :states, [])
    {context, _opts} = Keyword.pop(opts, :context, [])

    module
    |> Specimen.new(context)
    |> generate(factory, 1, states)
    |> List.first()
  end

  @doc """
  Makes many items as specified by the factory.

  ## Options

  - `:states` - A list of states to be applied to the item.
  - `:context` - A map or keyword list to act as a shared context.
  """
  def make_many(module, factory, count, opts \\ []) do
    {states, opts} = Keyword.pop(opts, :states, [])
    {context, _opts} = Keyword.pop(opts, :context, [])

    module
    |> Specimen.new(context)
    |> generate(factory, count, states)
  end

  defp generate(%Specimen{context: context} = specimen, factory, count, states) do
    generator = fn ->
      specimen
      |> factory.build()
      |> apply_states(factory, states)
      |> Specimen.to_struct()
      |> factory.after_making(context)
    end

    generator
    |> Stream.repeatedly()
    |> Enum.take(count)
  end

  defp apply_states(%{context: context} = specimen, factory, states) do
    Enum.reduce(states, specimen, fn state, specimen ->
      Specimen.transform(specimen, &apply(factory, :state, [state, &1, context]))
    end)
  end
end
