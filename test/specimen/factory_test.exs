defmodule Specimen.FactoryTest do
  use ExUnit.Case, async: true

  alias UserFixture, as: User
  alias UserFixtureFactory, as: Factory
  alias Specimen.TestRepo, as: Repo

  defmodule OtherModule, do: defstruct([:name])
  defmodule EmptyFactory, do: use(Specimen.Factory, module: User)

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

  test "factory accepts repo configuration" do
    defmodule UserFactoryWithRepoOption, do: use(Specimen.Factory, module: User, repo: Repo)

    assert %User{id: id} = UserFactoryWithRepoOption.create_one(states: [:status])
    assert %User{id: ^id} = Repo.get!(User, id)

    assert [%User{}] = UserFactoryWithRepoOption.create_many(1, states: [:status])
    assert %User{id: ^id} = Repo.get!(User, id)
  end

  test "factory accepts prefix configuration" do
    defmodule UserFactoryWithPrefixOption,
      do: use(Specimen.Factory, module: User, repo: Repo, prefix: "foo")

    assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "foo.users"/, fn ->
      UserFactoryWithPrefixOption.create_one(states: [:status])
    end

    assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "foo.users"/, fn ->
      UserFactoryWithPrefixOption.create_many(1, states: [:status])
    end
  end

  test "function options have priority over factory options" do
    defmodule UserFactoryWithOptions,
      do: use(Specimen.Factory, module: User, repo: Repo, prefix: "foo")

    assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "bar.users"/, fn ->
      UserFactoryWithOptions.create_one(prefix: "bar", states: [:status])
    end

    assert_raise Postgrex.Error, ~r/ERROR 42P01 \(undefined_table\) relation "bar.users"/, fn ->
      UserFactoryWithOptions.create_many(1, prefix: "bar", states: [:status])
    end
  end
end
