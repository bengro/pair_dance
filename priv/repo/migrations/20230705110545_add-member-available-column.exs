defmodule :"Elixir.PairDance.Infrastructure.Repo.Migrations.Add-member-available-column" do
  use Ecto.Migration

  def change do
    alter table(:members) do
      add :available, :boolean, null: false, default: true
    end
  end
end
