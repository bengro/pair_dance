defmodule PairDance.Infrastructure.User.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :email, :string
    field :name, :string
    field :avatar, :string
    field :last_login, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :avatar, :last_login])
    |> validate_required([:email])
    |> unique_constraint([:email])
  end
end
