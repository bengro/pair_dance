defmodule PairDance.Domain.Integration do
  alias PairDance.Domain.Integration.Settings
  alias PairDance.Domain.Integration.Credentials

  @enforce_keys [:id, :team_id, :settings, :credentials]
  defstruct [:id, :team_id, :settings, :credentials]

  @type t() :: %__MODULE__{
          id: String.t(),
          team_id: String.t(),
          settings: Settings.t(),
          credentials: Credentials.t()
        }

  def changeset(board_id, backlog_query) do
    types = %{
      board_id: :string,
      backlog_query: :string
    }

    {%{}, types}
    |> Ecto.Changeset.cast(%{board_id: board_id, backlog_query: backlog_query}, [
      :board_id,
      :backlog_query
    ])
    |> Ecto.Changeset.validate_required([:board_id, :backlog_query])
  end
end
