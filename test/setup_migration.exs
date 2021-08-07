defmodule Specimen.SetupMigration do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string)
      add(:lastname, :string)
      add(:status, :string)
      add(:password, :string)
      add(:email, :string)
      add(:age, :integer)
    end
  end
end
