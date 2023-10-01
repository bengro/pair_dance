defmodule PairDanceWeb.AppLive.SettingsPage do
  use PairDanceWeb, :live_view

  alias PairDance.Domain.Team.SlugService
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.Integrations.EctoRepository, as: IntegrationRepository
  alias PairDance.Infrastructure.EventBus

  @types %{
    name: :string
  }

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    EventBus.subscribe()

    user = session["current_user"]
    team = TeamRepository.find_by_slug?(slug)
    jira_integration = IntegrationRepository.find_by_team_id(team.descriptor.id)

    changeset =
      {%{}, @types}
      |> Ecto.Changeset.cast(%{name: team.descriptor.name}, [:name])
      |> Ecto.Changeset.validate_required(:name)

    team_form = Phoenix.HTML.FormData.to_form(changeset, as: "team_form")

    assigns =
      socket
      |> assign(:team, team)
      |> assign(:team_form, team_form)
      |> assign(:team_form_errors, %{name: []})
      |> assign(:current_user, user)
      |> assign(:page_title, "Settings")
      |> assign(:jira_client_id, Application.get_env(:pair_dance, :jira_client_id))

    {:ok, assigns}
  end

  @impl true
  def handle_event("delete_member", params, socket) do
    team = socket.assigns.team
    member_id = String.to_integer(params["member_id"])
    member_to_be_deleted = Enum.find(team.members, fn member -> member.id == member_id end)

    {:ok, updated_team} = TeamRepository.delete_member(team, member_to_be_deleted)

    {:noreply, assign(socket, :team, updated_team)}
  end

  @impl true
  def handle_event("delete_team", _, socket) do
    team = socket.assigns.team

    {:ok} = TeamRepository.delete(team.descriptor.id)

    {:noreply, push_navigate(socket, to: "/")}
  end

  def handle_event("save_team_details", %{"team_form" => %{"name" => team_name}}, socket) do
    changeset =
      {%{name: socket.assigns.team.descriptor.name}, @types}
      |> Ecto.Changeset.cast(%{name: team_name}, [:name])
      |> Ecto.Changeset.validate_required(:name)
      |> Ecto.Changeset.validate_length(:name, min: 4, max: 20)

    case changeset.valid? do
      true ->
        new_slug = SlugService.slugify(team_name)

        {:ok, _} =
          TeamRepository.update(socket.assigns.team.descriptor.id, %{
            name: team_name,
            slug: new_slug
          })

        assigns =
          socket
          |> put_flash(:info, "Settings changed")
          |> redirect(to: "/#{new_slug}/settings")

        {:noreply, assigns}

      false ->
        team_form = Phoenix.HTML.FormData.to_form(changeset, as: "team_form")
        team_form_errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)

        assigns =
          socket
          |> assign(:team_form, team_form)
          |> assign(:team_form_errors, team_form_errors)
          |> put_flash(:error, "Failed to save settings")

        {:noreply, assigns}
    end
  end

  @impl true
  def handle_info(%{team: team}, socket) do
    if team.descriptor.id == socket.assigns.team.descriptor.id do
      {:noreply, assign(socket, :team, team)}
    else
      {:noreply, socket}
    end
  end
end
