defmodule Specimen.FixtureTest do
  use ExUnit.Case
  doctest Specimen

  describe "elixir types" do
    test ":integer" do
      fixture = Specimen.create(:integer)
      assert is_integer(fixture)
    end

    test ":string" do
      fixture = Specimen.create(:string)
      assert is_binary(fixture)
      assert String.valid?(fixture)
    end

    test ":binary" do
      fixture = Specimen.create(:binary)
      assert is_binary(fixture)
      assert byte_size(fixture) == 10
      refute String.valid?(fixture)
    end

    test ":float" do
      fixture = Specimen.create(:float)
      assert is_float(fixture)
    end

    test ":boolean" do
      fixture = Specimen.create(:boolean)
      assert is_boolean(fixture)
    end

    test ":date_time" do
      fixture = Specimen.create(:date_time)
      assert %DateTime{} = fixture
    end

    test ":time" do
      fixture = Specimen.create(:time)
      assert %Time{} = fixture
    end

    test ":naive_date_time" do
      fixture = Specimen.create(:naive_date_time)
      assert %NaiveDateTime{} = fixture
    end
  end

  describe "ecto types/ aliases" do
    test ":id" do
      fixture = Specimen.create(:id)
      assert is_integer(fixture)
      assert fixture > 0
    end

    test ":binary_id" do
      fixture = Specimen.create(:binary_id)
      assert is_binary(fixture)
      assert byte_size(fixture) == 16
      refute String.valid?(fixture)
    end
  end
end
