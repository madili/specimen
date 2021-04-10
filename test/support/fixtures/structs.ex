alias Specimen.Fixtures.Factories.UserFactory

defmodule Specimen.Fixtures.Structs.User do
  defstruct [:name, :surname, :age, :email]
end

defmodule Specimen.Fixtures.Structs.FactorableUser do
  use Specimen.HasFactory, UserFactory

  defstruct [:name, :surname, :age, :email]

end
