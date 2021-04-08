defmodule Specimen do
  @moduledoc """
  Documentation for `Specimen`.
  """
  defdelegate create(type), to: Specimen.Fixture
  defdelegate create_many(type, count), to: Specimen.Fixture
end
