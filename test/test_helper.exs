ExUnit.start()

defmodule Specimen.TestRepo do
  use Ecto.Repo, otp_app: :specimen, adapter: Ecto.Adapters.Postgres
end

Application.put_env(:specimen, Specimen.TestRepo,
  url: "ecto://postgres:postgres@localhost/specimen_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false
)

_ = Ecto.Adapters.Postgres.storage_down(Specimen.TestRepo.config())

:ok = Ecto.Adapters.Postgres.storage_up(Specimen.TestRepo.config())

{:ok, _pid} = Specimen.TestRepo.start_link()

Code.require_file("setup_migration.exs", __DIR__)

:ok = Ecto.Migrator.up(Specimen.TestRepo, 0, Specimen.SetupMigration, log: false)
