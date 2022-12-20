defmodule PairDance.Teams.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
