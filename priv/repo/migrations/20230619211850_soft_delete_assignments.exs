defmodule PairDance.Infrastructure.Repo.Migrations.SoftDeleteAssignments do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    alter table(:assignments) do
      soft_delete_columns()
    end
  end
end
