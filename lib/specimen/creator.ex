defmodule Specimen.Creator do
  @moduledoc false

  alias Specimen.Maker

  @doc """
  Creates one item as specified by the factory.

  ## Options

  - `:repo` - The repo to use when inserting the item.
  - `:prefix` - The prefix to use when inserting the item.
  - `:states` - A list of states to be applied to the item.
  - `:context` - A map or keyword list to act as a shared context.
  """
  def create_one(module, factory, opts \\ []) do
    {repo, opts} = Keyword.pop!(opts, :repo)
    {prefix, opts} = Keyword.pop(opts, :prefix)
    {states, opts} = Keyword.pop(opts, :states, [])
    {context, _opts} = Keyword.pop(opts, :context, [])

    module
    |> Maker.make_one(factory, states: states, context: context)
    |> repo.insert!(prefix: prefix, returning: true)
    |> factory.after_creating(context)
  end

  @doc """
  Creates many items as specified by the factory.

  ## Options

  - `:repo` - The repo to use when inserting the item.
  - `:prefix` - The prefix to use when inserting the item.
  - `:states` - A list of states to be applied to the item.
  - `:context` - A map or keyword list to act as a shared context.
  """
  def create_many(module, factory, count, opts \\ []) do
    {repo, opts} = Keyword.pop!(opts, :repo)
    {prefix, opts} = Keyword.pop(opts, :prefix)
    {states, opts} = Keyword.pop(opts, :states, [])
    {context, _opts} = Keyword.pop(opts, :context, [])

    entries =
      module
      |> Maker.make_many(factory, count, states: states, context: context)
      |> Enum.map(&Map.drop(&1, [:__meta__, :__struct__, :id]))

    {_, entries} = repo.insert_all(module, entries, prefix: prefix, returning: true)

    Enum.map(entries, &factory.after_creating(&1, context))
  end
end
