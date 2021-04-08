defmodule Specimen.FixtureTest do
  use ExUnit.Case, async: true

  doctest Specimen.Fixture

  alias Specimen.Fixture

  describe "produces fixture for elixir type" do
    test ":integer" do
      fixture = Fixture.make(:integer)
      assert is_integer(fixture)
    end

    test ":string" do
      fixture = Fixture.make(:string)
      assert is_binary(fixture)
      assert String.valid?(fixture)
    end

    test ":binary" do
      fixture = Fixture.make(:binary)
      assert is_binary(fixture)
      assert byte_size(fixture) == 10
      refute String.valid?(fixture)
    end

    test ":float" do
      fixture = Fixture.make(:float)
      assert is_float(fixture)
    end

    test ":boolean" do
      fixture = Fixture.make(:boolean)
      assert is_boolean(fixture)
    end

    test ":date_time" do
      fixture = Fixture.make(:date_time)
      assert %DateTime{} = fixture
    end

    test ":time" do
      fixture = Fixture.make(:time)
      assert %Time{} = fixture
    end

    test ":naive_date_time" do
      fixture = Fixture.make(:naive_date_time)
      assert %NaiveDateTime{} = fixture
    end
  end
end
