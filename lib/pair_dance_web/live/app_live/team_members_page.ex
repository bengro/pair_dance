defmodule PairDanceWeb.TeamMembersLive.Index do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository

  @impl true
  def mount(%{"id" => team_id_str}, _session, socket) do
    { team_id, ""} = Integer.parse(team_id_str)
    team = TeamRepository.find(team_id)
    if team == nil do
      {:ok, assign(socket, :error, "not found")}
    else
      {:ok, assign(socket, :team, team)}
    end
  end

  @impl true
  def render( %{ error: "not found"} = assigns) do
    ~H"""
      <div>not found</div>
    """
  end

  @impl true
  def handle_info({:team_changed, team}, socket) do
    {:noreply, assign(socket, :team, team)}
  end

  def render(assigns) do
    ~H"""
    <h2>
    Team members:
    </h2>
    <.live_component
    id={1}
    module={PairDanceWeb.AppLive.AddMemberForm}
    team={@team}
    />
    <table>
      <tbody>
        <tr :for={member <- @team.members}>
          <td><%= member.user.email %></td>
        </tr>
      </tbody>
    </table>
    """
  end
end
