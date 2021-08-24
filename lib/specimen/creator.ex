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
  - `:overrides` - A list with field names and values to override.
  """
  def create_one(module, factory, opts \\ []) do
    {repo, opts} = Keyword.pop!(opts, :repo)
    {prefix, opts} = Keyword.pop(opts, :prefix)
    {states, opts} = Keyword.pop(opts, :states, [])
    {overrides, opts} = Keyword.pop(opts, :overrides, [])
    {context, _opts} = Keyword.pop(opts, :context, [])

    {[struct], [context]} =
      module
      |> Specimen.new(context)
      |> Builder.build(factory, 1, states, overrides)

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
  - `:overrides` - A map or keyword list to override the struct's field.
  """
  def create_many(module, factory, count, opts \\ []) do
    {repo, opts} = Keyword.pop!(opts, :repo)
    {prefix, opts} = Keyword.pop(opts, :prefix)
    {states, opts} = Keyword.pop(opts, :states, [])
    {overrides, opts} = Keyword.pop(opts, :overrides, [])
    {context, _opts} = Keyword.pop(opts, :context, [])

    {structs, contexts} =
      module
      |> Specimen.new(context)
      |> Builder.build(factory, count, states, overrides)

    structs =
      structs
      |> Enum.map(&repo.insert!(&1, prefix: prefix, returning: true))
      |> Enum.zip(contexts)
      |> Enum.map(fn {entry, context} -> factory.after_creating(entry, context) end)

    {structs, contexts}
  end

  @doc """
  Creates many items as specified by the factory.
  Differs from `create_many` in that the items are inserted in a single transaction.
  This function relies on `Repo.insert_all/3` for performance reasons and expects the `:patch` option to be passed.

  ## Options

  - `:repo` - The repo to use when inserting the item.
  - `:prefix` - The prefix to use when inserting the item.
  - `:states` - A list of states to be applied to the item.
  - `:context` - A map or keyword list to act as a shared context.`
  - `:patch` - A function of single arity that will be used to patch the structs into insertable entries.
  - `:overrides` - A map or keyword list to override the struct's field.
  """
  def create_all(module, factory, count, opts \\ []) do
    {repo, opts} = Keyword.pop!(opts, :repo)
    {patch, opts} = Keyword.pop!(opts, :patch)
    {prefix, opts} = Keyword.pop(opts, :prefix)
    {states, opts} = Keyword.pop(opts, :states, [])
    {overrides, opts} = Keyword.pop(opts, :overrides, [])
    {context, _opts} = Keyword.pop(opts, :context, [])

    {structs, contexts} =
      module
      |> Specimen.new(context)
      |> Builder.build(factory, count, states, overrides)

    entries = Enum.map(structs, &apply(patch, [&1]))

    {_, entries} = repo.insert_all(module, entries, prefix: prefix, returning: true)

    entries =
      entries
      |> Enum.zip(contexts)
      |> Enum.map(fn {entry, context} -> factory.after_creating(entry, context) end)

    {entries, contexts}
  end
end
