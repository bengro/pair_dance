defmodule PairDanceWeb.AppLive.TeamPage.CreateTaskComponent do
  use PairDanceWeb, :live_component

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def render(assigns) do
    ~H"""
    <div class="my-5">
      <.simple_form
        :let={f}
        for={%{}}
        as={:task}
        id="new-task-form"
        phx-target={@myself}
        phx-submit="save"
        phx-change="validate"
      >
        <.input field={{f, :name}} type="text" label="Task name" />
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
  def update(assigns, socket) do
    team = assigns[:team]
    {:ok, assign(socket, :team, team)}
  end

  @impl true
  def handle_event("validate", %{}, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
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
