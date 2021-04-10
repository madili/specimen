defmodule Specimen.MakerTest do
  use ExUnit.Case, async: true

  doctest Specimen.Maker

  alias Specimen.Maker

  alias Specimen.Fixtures.Structs.User
  alias Specimen.Fixtures.Factories.UserFactory

  describe "maker" do
    test "make_one/3 returns exactly one built struct" do
      assert %User{name: "John", surname: "Doe", age: 42} =
               Maker.make_one(User, UserFactory, [:surname])
    end

    test "make_many/4 returns the specified amount of structs built" do
      assert [%User{name: "John", surname: "Doe", age: 42}, _] =
               Maker.make_many(User, UserFactory, 2, [:surname])
    end
  end
end
