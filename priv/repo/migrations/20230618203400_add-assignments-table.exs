defmodule :"Elixir.PairDance.Infrastructure.Repo.Migrations.Add-assignments-table" do
  use Ecto.Migration

  def change do
    drop table(:assignments)

    create table(:assignments) do
      add :task_id, references(:tasks, on_delete: :delete_all), null: false
      add :member_id, references(:members, on_delete: :delete_all), null: false
      add :team_id, references(:teams, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:assignments, [:task_id])
    create index(:assignments, [:member_id])
    create index(:assignments, [:team_id])
  end
end
