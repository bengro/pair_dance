defmodule PairDance.Infrastructure.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :name, :string

      timestamps()
    end
  end
end
