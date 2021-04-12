alias Specimen.Fixtures.Structs.{User, SchemableUser}

defmodule Specimen.Fixtures.Factories.DefaultUserFactory do
  use Specimen.Factory, User
end

defmodule Specimen.Fixtures.Factories.UserFactory do
  use Specimen.Factory, User

  def build(specimen) do
    Specimen.include(specimen, :name, "John")
  end

  def state(:surname, %User{} = user) do
    Map.put(user, :surname, "Doe")
  end

  def after_making(%User{} = user) do
    Map.put(user, :age, 42)
  end
end

defmodule Specimen.Fixtures.Factories.SchemableUserFactory do
  use Specimen.Factory, SchemableUser

  def build(specimen) do
    Specimen.fill(specimen)
  end

  # TODO: Check hook after inserting when we are integrating with ecto
  # def after_creating(%User{name: name, surname: surname} = user) do
  #   %{user | email: String.downcase("#{name}.#{surname}@mail.com")}
  # end
end
