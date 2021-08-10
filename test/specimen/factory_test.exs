defmodule Specimen.FactoryTest do
  use ExUnit.Case, async: true

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory
  alias Specimen.TestRepo, as: Repo

  defmodule OtherModule, do: defstruct([:name])
  defmodule EmptyFactory, do: use(Specimen.Factory, User)

  test "build/1 on an empty factory raises when using a different module" do
    specimen = Specimen.new(OtherModule)

    message = "This factory can't be used to build Specimen.FactoryTest.OtherModule"

    assert_raise RuntimeError, message, fn -> EmptyFactory.build(specimen) end
  end

  test "make_one/1 is exposed in the factory" do
    assert %User{name: "Joe", lastname: "Schmoe", status: "active"} =
             Factory.make_one(states: [:status])
  end

  test "make_many/2 is exposed in the factory" do
    assert [%User{name: "Joe", lastname: "Schmoe", status: "active"}] =
             Factory.make_many(1, states: [:status])
  end

  test "create_one/1 is exposed in the factory" do
    assert %User{id: id} = Factory.create_one(repo: Repo, states: [:status])
    assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
  end

  test "create_many/2 is exposed in the factory" do
    assert [%User{id: id}] = Factory.create_many(1, repo: Repo, states: [:status])
    assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
  end
end
