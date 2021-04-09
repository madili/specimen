defmodule Specimen.FixtureTest do
  use ExUnit.Case
  doctest Specimen.Fixture

  describe "elixir types" do
    test ":integer" do
      fixture = Specimen.make(:integer)
      assert is_integer(fixture)
    end

    test ":string" do
      fixture = Specimen.make(:string)
      assert is_binary(fixture)
      assert String.valid?(fixture)
    end

    test ":binary" do
      fixture = Specimen.make(:binary)
      assert is_binary(fixture)
      assert byte_size(fixture) == 10
      refute String.valid?(fixture)
    end

    test ":float" do
      fixture = Specimen.make(:float)
      assert is_float(fixture)
    end

    test ":boolean" do
      fixture = Specimen.make(:boolean)
      assert is_boolean(fixture)
    end

    test ":date_time" do
      fixture = Specimen.make(:date_time)
      assert %DateTime{} = fixture
    end

    test ":time" do
      fixture = Specimen.make(:time)
      assert %Time{} = fixture
    end

    test ":naive_date_time" do
      fixture = Specimen.make(:naive_date_time)
      assert %NaiveDateTime{} = fixture
    end
  end

  describe "ecto types/ aliases" do
    test ":id" do
      fixture = Specimen.make(:id)
      assert is_integer(fixture)
      assert fixture > 0
    end

    test ":binary_id" do
      fixture = Specimen.make(:binary_id)
      assert is_binary(fixture)
      assert byte_size(fixture) == 16
      refute String.valid?(fixture)
    end
  end
end
