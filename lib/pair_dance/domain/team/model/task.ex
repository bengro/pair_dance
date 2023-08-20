defmodule PairDance.Domain.Team.Task do
  alias PairDance.Domain.Task.Descriptor
  alias PairDance.Domain.Team.AssignedMember

  @enforce_keys [:descriptor, :assigned_members]
  defstruct [:descriptor, :assigned_members]

  @type t() :: %__MODULE__{
          descriptor: Descriptor.t(),
          assigned_members: list(AssignedMember.t())
        }

  def changeset(task_name) do
    types = %{
      name: :string
    }

    {%{name: ""}, types}
    |> Ecto.Changeset.cast(%{name: task_name}, [:name])
    |> Ecto.Changeset.validate_required(:name)
    |> Ecto.Changeset.validate_length(:name, min: 4, max: 20)
  end
end
