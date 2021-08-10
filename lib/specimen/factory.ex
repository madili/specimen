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

      def make_one(opts \\ []),
        do: Specimen.Maker.make_one(@module, @factory, opts)

      def make_many(count, opts \\ []),
        do: Specimen.Maker.make_many(@module, @factory, count, opts)

      def create_one(opts \\ []),
        do: Specimen.Creator.create_one(@module, @factory, opts)

      def create_many(count, opts \\ []),
        do: Specimen.Creator.create_many(@module, @factory, count, opts)

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
