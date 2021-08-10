defmodule UserFixtureFactory do
  use Specimen.Factory, module: UserFixture

  def build(specimen) do
    specimen
    |> Specimen.include(:id)
    |> Specimen.include(:name, "Joe")
    |> Specimen.include(:lastname, "Schmoe")
    |> Specimen.exclude(:password)
  end

  def state(:status, %UserFixture{} = user) do
    %{user | status: "active"}
  end

  def after_making(%UserFixture{} = user) do
    %{user | age: System.unique_integer([:positive, :monotonic])}
  end

  def after_creating(%UserFixture{name: name, lastname: lastname} = user) do
    %{user | email: String.downcase("#{name}.#{lastname}@mail.com")}
  end
end
