defmodule :"Elixir.PairDance.Infrastructure.Repo.Migrations.Soft-delete-tasks" do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    alter table(:tasks) do
      soft_delete_columns()
    end
  end
end
