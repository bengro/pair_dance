defmodule PairDance.Infrastructure.TaskOwnershipEntity do
  use Ecto.Schema
  import Ecto.Changeset

  alias  PairDance.Infrastructure.TeamMemberEntity
  alias  PairDance.Infrastructure.TaskEntity

  schema "task_ownerships" do

    field :team_id, :id
    belongs_to :task, TaskEntity
    belongs_to :member, TeamMemberEntity

    timestamps()
  end

  @doc false
  def changeset(task_ownership, attrs) do
    task_ownership
    |> cast(attrs, [])
    |> validate_required([])
  end
end
