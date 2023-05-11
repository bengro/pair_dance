defmodule PairDance.Infrastructure.AssignmentEntity do
  use Ecto.Schema
  import Ecto.Changeset

  alias  PairDance.Infrastructure.TeamEntity
  alias  PairDance.Infrastructure.Team.MemberEntity
  alias  PairDance.Infrastructure.TaskEntity

  @primary_key false
  schema "assignments" do

    belongs_to :team, TeamEntity, primary_key: true
    belongs_to :task, TaskEntity, primary_key: true
    belongs_to :member, MemberEntity, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(assignment, attrs) do
    assignment
    |> cast(attrs, [])
    |> validate_required([])
  end
end
