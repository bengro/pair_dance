defmodule PairDance.Infrastructure.Repo.Migrations.AddIntegrationsTable do
  use Ecto.Migration

  def change do
    create table(:integrations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :settings, :binary

      timestamps()
    end
  end
end
