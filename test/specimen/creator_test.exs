defmodule Specimen.CreatorTest do
  use ExUnit.Case, async: true

  doctest Specimen.Creator

  alias Specimen.Creator
  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory
  alias Specimen.TestRepo, as: Repo

  test "create_one/3 returns exactly one persisted struct" do
    assert %User{id: id} = Creator.create_one(User, Factory, Repo, [:status])
    assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
  end

  test "create_one/3 invokes after_creating callback" do
    user = Creator.create_one(User, Factory, Repo, [:status])
    assert user.email == String.downcase("#{user.name}.#{user.lastname}@mail.com")
  end

  test "create_many/4 returns the specified amount of structs persisted" do
    assert [%User{id: id}] = Creator.create_many(User, Factory, 1, Repo, [:status])
    assert %User{id: ^id, name: "Joe", lastname: "Schmoe", status: "active"} = Repo.get!(User, id)
  end

  test "create_many/4 applies after_creating callback" do
    [user] = Creator.create_many(User, Factory, 1, Repo, [:status])
    assert user.email == String.downcase("#{user.name}.#{user.lastname}@mail.com")
  end
end
