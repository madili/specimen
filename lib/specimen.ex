defmodule Specimen do
  @moduledoc false

  alias __MODULE__

  @type t :: %__MODULE__{}

  defstruct module: nil, struct: nil, funs: [], includes: [], excludes: []

  def new(module) do
    %Specimen{module: module, struct: struct!(module)}
  end

  def fill(%Specimen{} = specimen) do
    Specimen.Ecto.Reflector.maybe_autofill_specimen(specimen)
  end

  def include(%Specimen{} = specimen, field) do
    Map.update!(specimen, :includes, &Enum.uniq([field | &1]))
  end

  def include(%Specimen{} = specimen, field, value) do
    specimen
    |> include(field)
    |> Specimen.transform(&Map.put(&1, field, value))
  end

  def exclude(%Specimen{} = specimen, field) do
    Map.update!(specimen, :excludes, &Enum.uniq([field | &1]))
  end

  def transform(%Specimen{} = specimen, fun) when is_function(fun) do
    Map.update!(specimen, :funs, &[fun | &1])
  end

  def to_struct(%Specimen{module: module, struct: struct, funs: funs} = specimen) do
    %{includes: includes, excludes: excludes} = specimen

    fields =
      funs
      |> Enum.reverse()
      |> Enum.reduce(struct, fn fun, struct -> apply(fun, [struct]) end)
      |> Map.from_struct()
      |> Map.new(&map_struct_field(&1, includes, excludes))

    struct!(module, fields)
  end

  defp map_struct_field({key, value}, includes, excludes) do
    # TODO: Check if this is the best implementation for includes/ excludes.
    # Questions to ask:
    # - Do we want to consider both includes and excludes?
    # - Will excludes always have precedence over includes?
    # - What should we do about default fields? Are they included by default?
    # - Should we consider included/ excluded fields before transforming functions?
    # - How will this work for autofill? Will excludes/ includes be only metadata or enforced?
    case {key, key in includes, key in excludes} do
      {key, _, true} -> {key, nil}
      {key, _, false} -> {key, value}
    end
  end
end
