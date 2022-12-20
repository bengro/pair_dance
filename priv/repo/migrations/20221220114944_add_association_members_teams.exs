defmodule PairDance.Repo.Migrations.ChangeMembersAssociation do
  use Ecto.Migration

  def change do
    alter table(:members) do
      add :team_id, references(:teams, on_delete: :nothing)
    end

    create index(:members, [:team_id])
  end
end
