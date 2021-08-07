defmodule UserFixture do
  use Ecto.Schema
  use Specimen.HasFactory, UserFixtureFactory

  schema "users" do
    field(:name, :string, default: "John")
    field(:lastname, :string, default: "Doe")
    field(:status, :string)
    field(:password, :string)
    field(:email, :string)
    field(:age, :integer)
  end
end
