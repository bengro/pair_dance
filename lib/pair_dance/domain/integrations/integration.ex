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

  def is_configured(integration) do
    if integration != nil and
         integration.settings != nil and
         integration.settings.board_id != nil and
         integration.settings.upcoming_tickets_jql != nil and
         integration.settings.inprogress_tickets_jql != nil do
      true
    else
      false
    end
  end

  def changeset(board_id, upcoming_tickets_jql, inprogress_tickets_jql) do
    types = %{
      board_id: :string,
      upcoming_tickets_jql: :string,
      inprogress_tickets_jql: :string
    }

    {%{}, types}
    |> Ecto.Changeset.cast(
      %{
        board_id: board_id,
        upcoming_tickets_jql: upcoming_tickets_jql,
        inprogress_tickets_jql: inprogress_tickets_jql
      },
      [
        :board_id,
        :upcoming_tickets_jql,
        :inprogress_tickets_jql
      ]
    )
    |> Ecto.Changeset.validate_required([
      :board_id,
      :upcoming_tickets_jql,
      :inprogress_tickets_jql
    ])
  end
end
