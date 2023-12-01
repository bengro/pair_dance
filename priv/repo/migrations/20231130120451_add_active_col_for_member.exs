defmodule PairDance.Infrastructure.Repo.Migrations.AddActiveColForMember do
  use Ecto.Migration

  def change do
    alter table(:members) do
      add :active, :boolean, null: false, default: true
    end
  end
end
