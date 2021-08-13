defmodule Specimen do
  @moduledoc """
  A Specimen holds the representatino of how to build a given struct.
  A Specimen works similary to an Elixir Stream in the sense that it's lazy-evaluated.
  Each value modification is stored as a list of functions that is later evaluated when you convert the Specimen to a struct.
  """

  alias __MODULE__

  @type t :: %__MODULE__{}

  defstruct module: nil, struct: nil, funs: [], includes: [], excludes: []

  @doc """
  Creates a new Specimen.
  """
  def new(module) do
    %Specimen{module: module, struct: struct!(module)}
  end

  @doc """
  Fills the Specimen fields automatically with random data.
  """
  def fill(%Specimen{} = specimen) do
    Specimen.Ecto.Reflector.maybe_autofill_specimen(specimen)
  end

  @doc """
  Includes the field in the list of fields to be generated.
  """
  def include(%Specimen{} = specimen, field) do
    Map.update!(specimen, :includes, &Enum.uniq([field | &1]))
  end

  @doc """
  Includes the field in the list of fields to be generated with a specific value.
  """
  def include(%Specimen{} = specimen, field, value) do
    specimen
    |> include(field)
    |> Specimen.transform(&Map.put(&1, field, value))
  end

  @doc """
  Includes the field in the list of fields to be generated randomly from the given list of values.
  """
  def vary(%Specimen{} = specimen, field, list) do
    specimen
    |> include(field)
    |> include(field, Enum.random(list))
  end

  @doc """
  Excludes the field from the list of fields to be generated.
  Excluded fields will be nilified in the generated struct.
  """
  def exclude(%Specimen{} = specimen, field) do
    Map.update!(specimen, :excludes, &Enum.uniq([field | &1]))
  end

  @doc """
  Adds a transformation to the given field using a function.
  """
  def transform(%Specimen{} = specimen, fun) when is_function(fun) do
    Map.update!(specimen, :funs, &[fun | &1])
  end

  @doc """
  Converts the Specimen into a struct.
  """
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
