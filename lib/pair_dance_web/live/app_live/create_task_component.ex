defmodule PairDanceWeb.AppLive.CreateTaskComponent do
  use PairDanceWeb, :live_component

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        :let={f}
        for={:task}
        id="new-task-form"
        phx-target={@myself}
        phx-submit="save"
        phx-change="validate"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Task</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    team = assigns[:team]
    {:ok, assign(socket, :team, team)}
  end

  @impl true
  def handle_event("validate", %{}, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, task_params)
  end

  defp save_task(socket, task_params) do
    %{"name" => task_name} = task_params

    case TeamRepository.add_task(socket.assigns.team, task_name) do
      {:ok, team} ->
        send(self(), {:team_changed, team})

        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")}
    end
  end
end
