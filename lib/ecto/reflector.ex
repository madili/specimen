defmodule Specimen.Ecto.Reflector do
  @moduledoc false

  def maybe_autofill_specimen(%{module: module} = specimen) do
    maybe_autofill_specimen(specimen, is_ecto_schema?(module))
  end

  defp maybe_autofill_specimen(specimen, false), do: specimen

  defp maybe_autofill_specimen(%{module: module} = specimen, true) do
    module
    |> fields_with_types()
    |> apply_fixtures(specimen)
  end

  defp is_ecto_schema?(module) do
    Enum.any?(module.__info__(:functions), &match?({:__schema__, _}, &1))
  end

  defp fields_with_types(module) do
    fields = module.__schema__(:fields)
    Enum.map(fields, &{&1, module.__schema__(:type, &1)})
  end

  defp apply_fixtures(fields_with_types, %{} = specimen) do
    Enum.reduce(fields_with_types, specimen, &make_fixture/2)
  end

  # TODO: Generate Ecto specific types fixtures.
  # See if we want to incorporate these in the 'main' workflow in the future under a different alias.
  defp make_fixture({field, :id}, specimen) do
    Specimen.with(specimen, field, System.unique_integer([:positive, :monotonic]))
  end

  defp make_fixture({field, :binary_id}, specimen) do
    Specimen.with(specimen, field, UUID.string_to_binary!(UUID.uuid4(:hex)))
  end

  defp make_fixture({field, type}, specimen) do
    Specimen.with(specimen, field, Specimen.Fixture.make(type))
  end
end
