defmodule PairDance.Infrastructure.Repo.Migrations.RenameAssignmentsTable do
  use Ecto.Migration

  def change do
    rename table(:task_ownerships), to: table(:assignments)
  end
end
