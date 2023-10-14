defmodule PairDanceWeb.AppLive.TeamPage.JiraTicketComponentTest do
  use PairDance.DataCase
  import Phoenix.LiveViewTest

  alias PairDanceWeb.AppLive.TeamPage.JiraTicketComponent
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.Integrations.EctoRepository, as: IntegrationRepository

  test "does not show upcoming jira tickets which are already in flight" do
    {:ok, team} = TeamRepository.create("Team Comet")
    {:ok, team} = TeamRepository.add_task(team, "name-is-ignored", "PD-1")
    {:ok, integration} = IntegrationRepository.create(team.descriptor.id, %{})

    html =
      render_component(JiraTicketComponent,
        team_id: team.descriptor.id,
        integration: integration,
        id: "make-myself-work"
      )

    refute html =~ "Become FedRamp compliant"
  end
end
