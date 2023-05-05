defmodule PairDance.Infrastructure.Repo.Migrations.AddUserEmail do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :name
      add :email, :string
    end
  end
end
