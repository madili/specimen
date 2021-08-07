defmodule Specimen.SetupMigration do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string)
      add(:surname, :string)
      add(:age, :integer)
      add(:email, :string)
    end
  end
end
