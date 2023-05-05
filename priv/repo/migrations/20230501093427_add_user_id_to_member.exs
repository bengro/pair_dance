defmodule PairDance.Infrastructure.Repo.Migrations.AddUserIdToMember do
  use Ecto.Migration

  def change do
    alter table(:members) do
      remove :name
      add(:user_id, :uuid, [references(:users, on_delete: :nothing)])
    end

    create index(:members, [:user_id])
  end
end
