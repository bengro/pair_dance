defmodule PairDance.Infrastructure.Team.MemberEntity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    belongs_to :user, PairDance.Infrastructure.UserEntity, references: :id, type: :binary_id
    belongs_to :team, PairDance.Infrastructure.TeamEntity

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:user_id, :team_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:team_id)
    |> validate_required([:user_id, :team_id])
  end
end
