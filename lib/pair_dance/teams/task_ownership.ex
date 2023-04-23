defmodule PairDance.Teams.TaskOwnership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_ownerships" do

    field :task_id, :id
    field :member_id, :id

    timestamps()
  end

  @doc false
  def changeset(task_ownership, attrs) do
    task_ownership
    |> cast(attrs, [])
    |> validate_required([])
  end
end
