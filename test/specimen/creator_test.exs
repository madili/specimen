defmodule Specimen.CreatorTest do
  use ExUnit.Case, async: true

  doctest Specimen.Creator

  import Ecto.Query

  alias Specimen.Creator

  alias Specimen.Fixtures.Structs.SchemableUser
  alias Specimen.Fixtures.Factories.SchemableUserFactory

  alias Specimen.TestRepo, as: Repo

  describe "creator" do
    test "create_one/3 persists exactly one built struct" do
      assert %SchemableUser{
               id: id,
               __meta__: %Ecto.Schema.Metadata{state: :loaded, source: "users"}
             } = Creator.create_one(SchemableUser, SchemableUserFactory, Repo, [:surname])

      assert %SchemableUser{id: ^id} = Repo.get!(SchemableUser, id)
    end

    test "create_one/3 applies after_creating callback" do
      user = Creator.create_one(SchemableUser, SchemableUserFactory, Repo, [:surname])
      assert user.email == String.downcase("#{user.name}.#{user.surname}@mail.com")
    end

    test "create_many/4 persists exactly the specified amount of structs built" do
      assert [%SchemableUser{__meta__: %Ecto.Schema.Metadata{state: :loaded, source: "users"}}, _] =
               users =
               Creator.create_many(SchemableUser, SchemableUserFactory, 2, Repo, [:surname])

      assert Enum.all?(users, fn %{id: id} ->
               match?(%SchemableUser{id: ^id}, Repo.get!(SchemableUser, id))
             end)
    end

    test "create_many/4 applies after_creating callback" do
      users = Creator.create_many(SchemableUser, SchemableUserFactory, 2, Repo, [:surname])

      assert Enum.all?(users, fn user ->
               user.email == String.downcase("#{user.name}.#{user.surname}@mail.com")
             end)
    end
  end
end
