defmodule PairDance.Infrastructure.Repo.Migrations.AddTeamIdToIntegrationTable do
  use Ecto.Migration

  def change do
    alter table(:integrations) do
      add :team_id, references(:teams, on_delete: :nothing)
    end

    create index(:integrations, [:team_id])
  end
end
