defmodule Specimen.Builder do
  @moduledoc """
  The module responsible for building specimens given the specified constraints.
  This module is mainly used internaly by `Specimen.Maker` and `Specimen.Creator`.
  """

  @type context :: map() | keyword()

  @doc false
  @spec build(Specimen.t(), module(), integer(), list(), list()) :: {[struct()], [context()]}
  def build(%Specimen{} = specimen, factory, count, states, overrides) do
    generator = fn -> generate(specimen, factory, states, overrides) end

    generator
    |> Stream.repeatedly()
    |> Enum.take(count)
    |> Enum.reduce({[], []}, &collect_contexts/2)
  end

  defp generate(specimen, factory, states, overrides) do
    specimen =
      specimen
      |> factory.build()
      |> apply_states(factory, states)

    specimen =
      Enum.reduce(overrides, specimen, fn {field, value}, specimen ->
        Specimen.override(specimen, field, value)
      end)

    {struct, context} = Specimen.to_struct(specimen)

    struct = factory.after_making(struct, context)

    {struct, context}
  end

  defp apply_states(%{context: context} = specimen, factory, states) do
    Enum.reduce(states, specimen, fn state, specimen ->
      Specimen.transform(specimen, &apply(factory, :state, [state, &1, context]))
    end)
  end

  defp collect_contexts({struct, context}, {structs, contexts}) do
    {[struct | structs], [context | contexts]}
  end
end
