defmodule Specimen.FactoryTest do
  use ExUnit.Case, async: true

  doctest Specimen.Factory

  alias Specimen.Fixtures.Factories.{DefaultUserFactory, UserFactory}
  alias Specimen.Fixtures.Structs.{User}

  describe "factory" do
    test "build/1 without configuration returns an unmodified specimen" do
      specimen = Specimen.new(User)
      assert specimen == DefaultUserFactory.build(specimen)
    end

    test "build/1 raises when using invalid module" do
      specimen = Specimen.new(UnknownModule)

      assert_raise RuntimeError, "This factory can't be used to build UnknownModule", fn ->
        DefaultUserFactory.build(specimen)
      end
    end

    test "state/2 without configuration returns an unmodified specimen" do
      specimen = Specimen.new(User)
      assert specimen == DefaultUserFactory.state(:state, specimen)
    end

    test "after_making/2 without configuration returns an unmodified specimen" do
      specimen = Specimen.new(User)
      assert specimen == DefaultUserFactory.after_making(specimen)
    end

    test "after_creating/2 without configuration returns an unmodified struct" do
      struct = %User{}
      assert struct == DefaultUserFactory.after_making(struct)
    end

    test "make_one/0 returns transforms from build" do
      assert %User{name: "John"} = UserFactory.make_one()
    end

    test "make_one/2 returns transforms from states" do
      assert %User{name: "John", surname: "Doe"} = UserFactory.make_one([:surname])
    end

    test "make_many/1 returns transforms from build" do
      assert [%User{name: "John"}, _] = UserFactory.make_many(2)
    end

    test "make_many/2 returns transforms from states" do
      assert [%User{name: "John", surname: "Doe"}, _] = UserFactory.make_many(2, [:surname])
    end
  end
end
