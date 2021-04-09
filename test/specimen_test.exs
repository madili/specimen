defmodule SpecimenTest do
  use ExUnit.Case
  doctest Specimen

  defmodule User do
    defstruct [:name, :age]
  end

  describe "specimen" do
    alias SpecimenTest.User

    test "build specimen" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.build()

      assert %Specimen{result: user, built?: true} = specimen
      assert %User{name: nil, age: nil} = user
    end

    test "build specimen with fun" do
      specimen =
        User
        |> Specimen.new()
        |> Specimen.with(&%{&1 | name: "John Doe"})
        |> Specimen.build()

      assert %Specimen{result: user, built?: true} = specimen
      assert %User{name: "John Doe", age: nil} = user
    end
  end
end
