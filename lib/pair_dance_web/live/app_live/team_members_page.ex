defmodule PairDanceWeb.TeamMembersLive.Index do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    team = TeamRepository.find_by_slug(slug)
    if team == nil do
      {:ok, assign(socket, :error, "not found")}
    else
      {:ok, assign(socket, :team, team)}
    end
  end

  @impl true
  def handle_info({:team_changed, team}, socket) do
    {:noreply, assign(socket, :team, team)}
  end

  @impl true
  def render( %{ error: "not found"} = assigns) do
    ~H"""
    <div>not found</div>
    """
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
