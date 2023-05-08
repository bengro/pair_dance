defmodule PairDance.Infrastructure.Repo.Migrations.AddUserProfile do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :avatar, :string
    end
  end
end
