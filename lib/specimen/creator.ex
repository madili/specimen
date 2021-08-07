defmodule Specimen.Creator do
  @moduledoc false

  alias Specimen.Maker

  def create_one(module, factory, repo, states) do
    module
    |> Maker.make_one(factory, states)
    |> repo.insert!()
    |> factory.after_creating()
  end

  def create_many(module, factory, count, repo, states) do
    entries =
      module
      |> Maker.make_many(factory, count, states)
      |> Enum.map(&Map.drop(&1, [:__meta__, :__struct__]))

    {_, entries} = repo.insert_all(module, entries, returning: true)

    Enum.map(entries, &factory.after_creating/1)
  end
end
