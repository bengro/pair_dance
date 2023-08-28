defmodule PairDance.Infrastructure.Repo.Migrations.AddLastActiveTeam do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :last_active_team_id, references(:teams, on_delete: :nilify_all),
        null: true,
        default: nil
    end
  end
end
