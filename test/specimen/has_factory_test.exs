defmodule Specimen.HasFactoryTest do
  use ExUnit.Case, async: true

  doctest Specimen.Maker

  alias Specimen.Fixtures.Structs.{User, FactorableUser}

  describe "has_factory" do
    test "make_one/1" do
      assert %User{} = FactorableUser.Factory.make_one()
    end

    test "make_many/2" do
      assert [%User{}, _] = FactorableUser.Factory.make_many(2)
    end
  end
end
