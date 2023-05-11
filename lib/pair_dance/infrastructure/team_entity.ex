defmodule PairDance.Infrastructure.TeamEntity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :slug, :string
    has_many(:members, PairDance.Infrastructure.TeamMemberEntity, foreign_key: :team_id)
    has_many(:tasks, PairDance.Infrastructure.TaskEntity, foreign_key: :team_id)
    has_many(:assignments, PairDance.Infrastructure.TaskOwnershipEntity, foreign_key: :team_id)

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint([:slug])
  end
end
