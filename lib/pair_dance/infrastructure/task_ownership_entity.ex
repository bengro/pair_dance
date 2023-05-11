defmodule PairDance.Infrastructure.AssignmentEntity do
  use Ecto.Schema
  import Ecto.Changeset

  alias  PairDance.Infrastructure.TeamEntity
  alias  PairDance.Infrastructure.TeamMemberEntity
  alias  PairDance.Infrastructure.TaskEntity

  @primary_key false
  schema "assignments" do

    belongs_to :team, TeamEntity, primary_key: true
    belongs_to :task, TaskEntity, primary_key: true
    belongs_to :member, TeamMemberEntity, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(task_ownership, attrs) do
    task_ownership
    |> cast(attrs, [])
    |> validate_required([])
  end
end
