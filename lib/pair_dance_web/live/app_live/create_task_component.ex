defmodule PairDanceWeb.AppLive.CreateTaskComponent do
  use PairDanceWeb, :live_component

  alias PairDance.Teams
  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        :let={f}
        for={@changeset}
        id="new-task-form"
        phx-target={@myself}
        phx-submit="save"
        phx-change="validate"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <.input field={{f, :team_id}} type="hidden" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Task</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    changeset = Teams.change_task(assigns.task)

    {:ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      socket.assigns.task
      |> Teams.change_task(task_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, task_params)
  end

  defp save_task(socket, task_params) do
    %{ "name" => task_name, "team_id" => team_id } = task_params
    team = TeamRepository.find(team_id)
    case TeamRepository.add_task(team, task_name) do
      {:ok, team} ->
        send(self(), {:team_changed, team})
        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
        }
    end
  end
end
