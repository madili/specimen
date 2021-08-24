defmodule Specimen.Maker do
  @moduledoc false

  alias Specimen.Builder

  @doc """
  Makes one item as specified by the factory.

  ## Options

  - `:states` - A list of states to be applied to the item.
  - `:context` - A map or keyword list to act as a shared context.
  - `:overrides` - A list with field names and values to override.
  """
  def make_one(module, factory, opts \\ []) do
    {states, opts} = Keyword.pop(opts, :states, [])
    {overrides, opts} = Keyword.pop(opts, :overrides, [])
    {context, _opts} = Keyword.pop(opts, :context, [])

    {[item], [context]} =
      module
      |> Specimen.new(context)
      |> Builder.build(factory, 1, states, overrides)

    {item, context}
  end

  @doc """
  Makes many items as specified by the factory.

  ## Options

  - `:states` - A list of states to be applied to the item.
  - `:context` - A map or keyword list to act as a shared context.
  - `:overrides` - A list with field names and values to override.
  """
  def make_many(module, factory, count, opts \\ []) do
    {states, opts} = Keyword.pop(opts, :states, [])
    {overrides, opts} = Keyword.pop(opts, :overrides, [])
    {context, _opts} = Keyword.pop(opts, :context, [])

    module
    |> Specimen.new(context)
    |> Builder.build(factory, count, states, overrides)
  end
end
