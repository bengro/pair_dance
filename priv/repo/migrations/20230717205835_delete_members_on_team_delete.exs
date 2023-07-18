defmodule PairDance.Infrastructure.Repo.Migrations.DeleteMembersOnTeamDelete do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE members DROP CONSTRAINT members_team_id_fkey"
    execute "ALTER TABLE tasks DROP CONSTRAINT tasks_team_id_fkey"

    alter table(:members) do
      modify :team_id, references(:teams, on_delete: :delete_all), null: false
    end

    alter table(:tasks) do
      modify :team_id, references(:teams, on_delete: :delete_all), null: false
    end
  end
end
