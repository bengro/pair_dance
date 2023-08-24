defmodule PairDance.Domain.Team.Member do
  alias PairDance.Domain.User

  @enforce_keys [:user, :role]
  defstruct [:id, :user, :role, :available, :last_login]

  @type team_role :: :admin | :user

  @type t() :: %__MODULE__{
          id: String.t(),
          user: User.t(),
          role: team_role(),
          available: boolean,
          last_login: Phoenix.HTML.Safe.DateTime.t()
        }

  def changeset(email) do
    types = %{
      email: :string
    }

    {%{email: ""}, types}
    |> Ecto.Changeset.cast(%{email: email}, [:email])
    |> Ecto.Changeset.validate_required(:email)
    |> Ecto.Changeset.validate_format(:email, ~r/@/)
    |> Ecto.Changeset.validate_length(:email, min: 5, max: 150)
  end
end
