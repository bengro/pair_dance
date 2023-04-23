defmodule PairDance.Repo.Migrations.CreateTaskOwnerships do
  use Ecto.Migration

  def change do
    create table(:task_ownerships) do
      add :task_id, references(:tasks, on_delete: :nothing)
      add :member_id, references(:members, on_delete: :nothing)

      timestamps()
    end

    create index(:task_ownerships, [:task_id])
    create index(:task_ownerships, [:member_id])
  end
end
