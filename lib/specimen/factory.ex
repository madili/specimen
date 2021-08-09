defmodule Specimen.Factory do
  @moduledoc false

  @callback build(Specimen.t()) :: Specimen.t()

  @callback state(atom(), struct()) :: struct()

  @callback after_making(struct()) :: struct()

  @callback after_creating(struct()) :: struct()

  defmacro __using__(module) do
    quote do
      @behaviour Specimen.Factory

      @module unquote(module)
      @factory __MODULE__

      def make_one(states \\ []),
        do: Specimen.Maker.make_one(@module, @factory, states)

      def make_many(count, states \\ []),
        do: Specimen.Maker.make_many(@module, @factory, count, states)

      def create_one(repo, states \\ []),
        do: Specimen.Creator.create_one(@module, @factory, repo, states)

      def create_many(count, repo, states \\ []),
        do: Specimen.Creator.create_many(@module, @factory, count, repo, states)

      def build(%Specimen{module: module}) when module != unquote(module) do
        raise "This factory can't be used to build #{inspect(module)}"
      end

      def build(specimen), do: specimen

      def state(_state, struct), do: struct

      def after_making(struct), do: struct

      def after_creating(struct), do: struct

      defoverridable build: 1, state: 2, after_making: 1, after_creating: 1
    end
  end
end
