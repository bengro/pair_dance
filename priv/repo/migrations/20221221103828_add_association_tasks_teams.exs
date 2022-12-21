defmodule PairDance.Repo.Migrations.AddAssociationTasksTeams do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :team_id, references(:teams, on_delete: :nothing)
    end

    create index(:tasks, [:team_id])
  end
end
