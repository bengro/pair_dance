defmodule PairDance.Infrastructure.Repo.Migrations.RemovePrimaryKeyForTaskOwnerships do
  use Ecto.Migration

  def change do
    alter table(:task_ownerships) do
      remove :id
      modify(:member_id, :id, primary_key: true)
      modify(:task_id, :id, primary_key: true)
      modify(:team_id, :id, primary_key: true)
    end
  end
end
