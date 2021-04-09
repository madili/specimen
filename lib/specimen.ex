defmodule Specimen do
  @moduledoc """
  Documentation for `Specimen`.
  """

  alias __MODULE__

  @enforce_keys [:module, :built?]
  defstruct module: nil,
            result: nil,
            built?: false,
            fill?: false,
            discard: [],
            funs: []

  defguard is_fresh(specimen) when not is_nil(specimen.module) and not specimen.built?

  defdelegate make(type), to: Specimen.Fixture
  defdelegate make_many(type, count), to: Specimen.Fixture

  def new(module) do
    %Specimen{module: module, built?: false}
  end

  def autofill(%Specimen{} = specimen, boolean)
      when is_fresh(specimen)
      when is_boolean(boolean) do
    Map.put(specimen, :fill?, boolean)
  end

  def discard(%Specimen{} = specimen, fields)
      when is_fresh(specimen)
      when is_list(fields) do
    Map.put(specimen, :discard, fields)
  end

  def with(%Specimen{} = specimen, fun)
      when is_fresh(specimen)
      when is_function(fun) do
    Map.update!(specimen, :funs, &[fun | &1])
  end

  def with(%Specimen{} = specimen, field, value)
      when is_fresh(specimen)
      when is_atom(field) do
    Specimen.with(specimen, &Map.put(&1, field, value))
  end

  def build(%Specimen{} = specimen) when is_fresh(specimen) do
    specimen
    |> transform()
    |> Map.put(:built?, true)
  end

  defp transform(%Specimen{module: module, funs: funs} = specimen) do
    struct = struct!(module)

    result =
      funs
      |> Enum.reverse()
      |> Enum.reduce(struct, fn fun, acc -> apply(fun, [acc]) end)

    Map.put(specimen, :result, result)
  end
end
