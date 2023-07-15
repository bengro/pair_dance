defmodule PairDance.Infrastructure.Repo.Migrations.AddLastLoggedIn do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :last_login, :naive_datetime, null: true, default: nil
    end
  end
end
