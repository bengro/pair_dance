defmodule PairDanceWeb.AppLive.Settings.CreateMemberComponent do
  use PairDanceWeb, :live_component
  alias PairDance.Infrastructure.EventBus
  alias PairDance.Domain.Team.InviteService
  alias PairDance.Domain.Team.Member

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        :let={f}
        for={@new_member_form}
        as={:new_member_form}
        id="add-member-form"
        phx-target={@myself}
        phx-submit="save"
      >
        <.input
          field={{f, :email}}
          label="Add your team members by E-Mail."
          errors={@new_member_form_errors[:email]}
        />
        <:actions>
          <.button phx-disable-with="Adding..." data-qa="add-member-submit">
            Add
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    changeset = Member.changeset("")
    new_member_form = Phoenix.HTML.FormData.to_form(changeset, as: "new_member_form")

    assigns =
      socket
      |> assign(:new_member_form, new_member_form)
      |> assign(:new_member_form_errors, %{email: []})

    {:ok, assigns}
  end

  @impl true
  def update(assigns, socket) do
    team = assigns[:team]
    {:ok, assign(socket, :team, team)}
  end

  @impl true
  def handle_event("save", %{"new_member_form" => user}, socket) do
    changeset = Member.changeset(user["email"])
    new_member_form = Phoenix.HTML.FormData.to_form(changeset, as: "new_member_form")

    case changeset.valid? do
      true ->
        team = InviteService.invite(socket.assigns.team, user["email"])

        EventBus.broadcast(%{team: team})

        assigns =
          socket
          |> assign(:new_member_form, Phoenix.HTML.FormData.to_form(%{}, as: "new_member_form"))
          |> assign(:new_member_form_errors, %{email: []})
          |> assign(team: team, user: nil)

        {:noreply, assigns}

      false ->
        new_member_form_errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)

        assigns =
          socket
          |> assign(:new_member_form, new_member_form)
          |> assign(:new_member_form_errors, new_member_form_errors)

        {:noreply, assigns}
    end
  end
end
