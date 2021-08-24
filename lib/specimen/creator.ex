defmodule Specimen.Creator do
  @moduledoc false

  alias Specimen.Builder

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

    {[struct], [context]} =
      module
      |> Specimen.new(context)
      |> Builder.build(factory, 1, states)

    struct =
      struct
      |> repo.insert!(prefix: prefix, returning: true)
      |> factory.after_creating(context)

    {struct, context}
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

    {structs, contexts} =
      module
      |> Specimen.new(context)
      |> Builder.build(factory, count, states)

    entries = Enum.map(structs, &Map.drop(&1, [:__meta__, :__struct__, :id]))

    {_, entries} = repo.insert_all(module, entries, prefix: prefix, returning: true)

    entries =
      entries
      |> Enum.zip(contexts)
      |> Enum.map(fn {entry, context} -> factory.after_creating(entry, context) end)

    {entries, contexts}
  end
end
