defmodule PairDance.Teams.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    field :name, :string
    belongs_to :team, PairDance.Teams.Team

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:name, :team_id])
    |> foreign_key_constraint(:team_id)
    |> validate_required([:name, :team_id])
  end
end
