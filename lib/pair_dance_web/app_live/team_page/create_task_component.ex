defmodule PairDanceWeb.AppLive.TeamPage.CreateTaskComponent do
  use PairDanceWeb, :live_component
  alias PairDance.Infrastructure.EventBus
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Domain.Team.Task

  @impl true
  def render(assigns) do
    ~H"""
    <div class="my-5">
      <.simple_form
        :let={f}
        for={@new_task_form}
        as={:new_task_form}
        id="new-task-form"
        phx-target={@myself}
        phx-submit="save"
      >
        <.input
          field={{f, :name}}
          type="text"
          label="Task name"
          errors={@new_task_form_errors[:name]}
        />
        <:actions>
          <.button data-qa="new-task-submit" phx-disable-with="Saving...">
            Add
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    changeset = Task.changeset("")
    new_task_form = Phoenix.HTML.FormData.to_form(changeset, as: "new_task_form")

    assigns =
      socket
      |> assign(:new_task_form, new_task_form)
      |> assign(:new_task_form_errors, %{name: []})

    {:ok, assigns}
  end

  @impl true
  def update(assigns, socket) do
    team = assigns[:team]

    assigns =
      socket
      |> assign(:team, team)

    {:ok, assigns}
  end

  def handle_event("save", %{"new_task_form" => %{"name" => task_name}}, socket) do
    changeset = Task.changeset(task_name)
    new_task_form = Phoenix.HTML.FormData.to_form(changeset, as: "new_task_form")

    case changeset.valid? do
      true ->
        {:ok, team} = TeamRepository.add_task(socket.assigns.team, task_name)
        EventBus.broadcast(%{team: team})

        {:noreply,
         socket
         |> assign(:team, team)
         |> assign(:new_task_form, Phoenix.HTML.FormData.to_form(%{}, as: "new_task_form"))
         |> assign(:new_task_form_errors, %{name: []})
         |> put_flash(:info, "Task created successfully")}

      false ->
        new_task_form_errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)

        {:noreply,
         socket
         |> assign(:new_task_form, new_task_form)
         |> assign(:new_task_form_errors, new_task_form_errors)
         |> put_flash(:error, "Task not created")}
    end
  end
end
