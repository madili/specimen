alias Specimen.Fixtures.Factories.UserFactory

defmodule Specimen.Fixtures.Structs.User do
  defstruct name: "Joseph", surname: nil, age: nil, email: nil
end

defmodule Specimen.Fixtures.Structs.FactorableUser do
  use Specimen.HasFactory, UserFactory

  defstruct name: "Joseph", surname: nil, age: nil, email: nil
end

defmodule Specimen.Fixtures.Structs.SchemableUser do
  use Ecto.Schema

  schema "users" do
    field(:name, :string, default: "Joseph")
    field(:surname, :string)
    field(:email, :string)
    field(:age, :integer)
  end
end
