defmodule PairDance.Infrastructure.Team.TaskEntity do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema

  schema "tasks" do
    field :name, :string
    field :external_id, :string
    belongs_to(:team, PairDance.Infrastructure.TeamEntity)

    timestamps()
    soft_delete_schema()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :team_id, :external_id])
    |> foreign_key_constraint(:team_id)
    |> validate_required([:name, :team_id])
  end
end
