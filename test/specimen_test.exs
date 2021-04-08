defmodule SpecimenTest do
  use ExUnit.Case, async: true

  doctest Specimen

  alias Specimen.Fixtures.Structs.{User, SchemableUser}

  describe "specimen" do
    test "new/1" do
      assert %Specimen{module: User} = Specimen.new(User)
    end

    test "fill/1" do
      specimen =
        SchemableUser
        |> Specimen.new()
        |> Specimen.fill()

      assert %Specimen{funs: funs} = specimen
      assert length(SchemableUser.__schema__(:fields)) == length(funs)
      assert %SchemableUser{} = Specimen.to_struct(specimen)
    end

    test "exclude/2" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.exclude(:name)

      assert %Specimen{excludes: [:name]} = specimen
      assert %User{name: nil} = Specimen.to_struct(specimen)
    end

    test "include/2" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.include(:name)

      assert %Specimen{includes: [:name]} = specimen
      assert %User{name: "Joseph"} = Specimen.to_struct(specimen)
    end

    test "include/3" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.include(:name, "John")

      assert %Specimen{includes: [:name]} = specimen
      assert %User{name: "John"} = Specimen.to_struct(specimen)
    end

    test "transform/2" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.transform(&Map.put(&1, :name, "John"))

      assert %User{name: "John"} = Specimen.to_struct(specimen)
    end
  end
end
