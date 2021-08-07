defmodule SpecimenFactoryTest do
  use ExUnit.Case, async: true

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory

  describe "specimen factory" do
    test "make_one/1 returns exactly one item" do
      assert %User{} = Factory.make_one()
    end

    test "make_many/2 returns the specified amount of items" do
      assert [%User{}, %User{}] = Factory.make_many(2)
    end

    # test "create_one/1 returns exactly one item" do
    #   assert %User{} = Factory.create_one()
    # end

    # test "create_many/2 returns the specified amount of items" do
    #   assert [%User{}, %User{}] = Factory.create_many(2)
    # end
  end
end
