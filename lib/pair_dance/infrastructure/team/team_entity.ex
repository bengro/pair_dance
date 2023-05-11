defmodule PairDance.Infrastructure.TeamEntity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :slug, :string
    has_many(:members, PairDance.Infrastructure.Team.MemberEntity, foreign_key: :team_id)
    has_many(:tasks, PairDance.Infrastructure.Team.TaskEntity, foreign_key: :team_id)
    has_many(:assignments, PairDance.Infrastructure.Team.AssignmentEntity, foreign_key: :team_id)

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
