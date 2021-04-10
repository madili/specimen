defmodule SpecimenTest do
  use ExUnit.Case, async: true

  doctest Specimen

  alias Specimen.Fixtures.Structs.User

  describe "specimen" do
    test "new/1" do
      assert %Specimen{module: User} = Specimen.new(User)
    end

    test "autofill/2" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.autofill(true)

      assert %Specimen{fill?: true} = specimen
    end

    test "discard/2" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.discard([:name])

      assert %Specimen{discard: [:name]} = specimen
    end

    test "with/2" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.with(&Map.put(&1, :name, "John"))
        |> Specimen.to_struct()

      assert %User{name: "John"} = specimen
    end

    test "with/3" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.with(:name, "John")
        |> Specimen.to_struct()

      assert %User{name: "John"} = specimen
    end
  end
end
