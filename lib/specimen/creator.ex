defmodule Specimen.Creator do
  @moduledoc false

  alias Specimen.Maker

  @doc """
  Creates one item as specified by the factory.

  ## Options

  - `:repo` - The repo to use when inserting the item.
  - `:prefix` - The prefix to use when inserting the item.
  - `:states` - A list of states to be applied to the item.
  """
  def create_one(module, factory, opts \\ []) do
    {repo, opts} = Keyword.pop!(opts, :repo)
    {prefix, opts} = Keyword.pop(opts, :prefix)
    {states, _opts} = Keyword.pop(opts, :states, [])

    module
    |> Maker.make_one(factory, states: states)
    |> repo.insert!(prefix: prefix, returning: true)
    |> factory.after_creating()
  end

  @doc """
  Creates many items as specified by the factory.

  ## Options

  - `:repo` - The repo to use when inserting the item.
  - `:prefix` - The prefix to use when inserting the item.
  - `:states` - A list of states to be applied to the item.
  """
  def create_many(module, factory, count, opts \\ []) do
    {repo, opts} = Keyword.pop!(opts, :repo)
    {prefix, opts} = Keyword.pop(opts, :prefix)
    {states, _opts} = Keyword.pop(opts, :states, [])

    entries =
      module
      |> Maker.make_many(factory, count, states: states)
      |> Enum.map(&Map.drop(&1, [:__meta__, :__struct__, :id]))

    {_, entries} = repo.insert_all(module, entries, prefix: prefix, returning: true)

    Enum.map(entries, &factory.after_creating/1)
  end
end
