defmodule Specimen.HasFactory do
  defmacro __using__(factory) do
    quote do
      defmodule Factory do
        defdelegate make_one(states \\ []), to: unquote(factory)
        defdelegate make_many(count, states \\ []), to: unquote(factory)
      end
    end
  end
end
