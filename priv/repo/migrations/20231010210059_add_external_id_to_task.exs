defmodule PairDance.Infrastructure.Repo.Migrations.AddExternalTaskId do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :external_id, :string, null: true, default: nil
    end

    create index(:tasks, [:external_id])
  end
end
