defmodule PairDance.Repo.Migrations.AddTeamSlug do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :slug, :string
    end
  end
end
