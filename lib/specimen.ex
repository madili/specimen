defmodule Specimen do
  @moduledoc false

  alias __MODULE__

  @type t :: %__MODULE__{}

  #TODO: pending behaviours:
  # - autofill using fixture when module is an Ecto Schema (since we can know the types)
  # - discard fields when creating the struct
  defstruct module: nil, fill?: false, discard: [], funs: []

  def new(module) do
    %Specimen{module: module}
  end

  def autofill(%Specimen{} = specimen, boolean) when is_boolean(boolean) do
    Map.put(specimen, :fill?, boolean)
  end

  def discard(%Specimen{} = specimen, fields) when is_list(fields) do
    Map.put(specimen, :discard, fields)
  end

  def with(%Specimen{} = specimen, fun) when is_function(fun) do
    Map.update!(specimen, :funs, &[fun | &1])
  end

  def with(%Specimen{} = specimen, field, value) when is_atom(field) do
    Specimen.with(specimen, &Map.put(&1, field, value))
  end

  def to_struct(%Specimen{module: module, funs: funs}) do
    struct = struct!(module)

    funs
    |> Enum.reverse()
    |> Enum.reduce(struct, fn fun, s -> apply(fun, [s]) end)
  end
end
