defmodule PairDance.Infrastructure.Repo.Migrations.MakeTeamSlugsUnique do
  use Ecto.Migration

  def change do
    create unique_index(:teams, [:slug])
  end
end
