defmodule Specimen.HasFactoryTest do
  use ExUnit.Case, async: true

  doctest Specimen.Maker

  alias UserFixture, as: User

  describe "using Specimen.HasFactory" do
    test "exposes a Factory.make_one/1 function inside the module" do
      assert %User{} = User.Factory.make_one()
    end

    test "exposes a Factory.make_many/2 function inside the module" do
      assert [%User{}, %User{}] = User.Factory.make_many(2)
    end
  end
end
