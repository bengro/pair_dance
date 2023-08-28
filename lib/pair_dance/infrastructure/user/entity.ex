defmodule PairDance.Infrastructure.User.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :email, :string
    field :name, :string
    field :avatar, :string
    field :last_login, :naive_datetime
    field :last_active_team_id, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :avatar, :last_login, :last_active_team_id])
    |> validate_required([:email])
    |> unique_constraint([:email])
  end
end
