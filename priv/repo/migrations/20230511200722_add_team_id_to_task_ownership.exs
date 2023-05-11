defmodule PairDance.Infrastructure.Repo.Migrations.AddTeamIdToTaskOwnership do
  use Ecto.Migration

  def change do
    alter table(:task_ownerships) do
      add :team_id, references(:teams, on_delete: :nothing), null: false
    end
  end
end
