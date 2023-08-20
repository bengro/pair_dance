defmodule PairDanceWeb.AppLive.TeamPage.EditableTask do
  use PairDanceWeb, :live_component

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.EventBus
  alias PairDance.Domain.Team.Task

  @impl true
  def update(assigns, socket) do
    team = assigns.team
    task = assigns.task
    id = assigns.id

    assigns =
      socket
      |> assign(:task, task)
      |> assign(:id, id)
      |> assign(:edit_mode, false)
      |> assign(:team, team)
      |> assign(:edit_task_form, task_edit_form(task))
      |> assign(:edit_task_form_errors, %{name: []})

    {:ok, assigns}
  end

  @impl true
  def handle_event("edit", %{}, socket) do
    assigns =
      socket
      |> assign(:edit_mode, true)

    {:noreply, assigns}
  end

  @impl true
  def handle_event(
        "save",
        %{"edit_task_form" => %{"name" => task_name}},
        socket
      ) do
    changeset = Task.changeset(task_name)
    edit_task_form = Phoenix.HTML.FormData.to_form(changeset, as: "edit_task_form")

    case changeset.valid? do
      true ->
        tasks = socket.assigns.team.tasks
        task_id = socket.assigns.task.id
        team = socket.assigns.team

        updated_task =
          Enum.find(tasks, fn task -> task.id == task_id end)
          |> struct(name: task_name)

        {:ok, updated_team} = TeamRepository.update_task(team, updated_task)

        assigns =
          socket
          |> assign(:team, updated_team)
          |> assign(:task, updated_task)
          |> assign(:edit_mode, false)
          |> assign(:edit_task_form, task_edit_form(updated_task))
          |> assign(:edit_task_form_errors, %{name: []})

        EventBus.broadcast(%{team: updated_team})

        {:noreply, assigns}

      false ->
        edit_task_form_errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)

        assigns =
          socket
          |> assign(:edit_mode, true)
          |> assign(:edit_task_form, edit_task_form)
          |> assign(:edit_task_form_errors, edit_task_form_errors)

        {:noreply, assigns}
    end
  end

  @impl true
  def handle_event("cancel_edit", %{"value" => _}, socket) do
    task = socket.assigns.task

    assigns =
      socket
      |> assign(:edit_mode, false)
      |> assign(:edit_task_form, task_edit_form(task))
      |> assign(:edit_task_form_errors, %{name: []})

    {:noreply, assigns}
  end

  @impl true
  def handle_event("delete_task", %{"task_id" => task_id}, socket) do
    team = socket.assigns.team
    task = Enum.find(team.tasks, fn task -> task.id == String.to_integer(task_id) end)

    {:ok, updated_team} = TeamRepository.delete_task(team, task)
    EventBus.broadcast(%{team: updated_team})

    {:noreply,
     socket
     |> assign(:team, updated_team)}
  end

  defp task_edit_form(task) do
    changeset = Task.changeset(task.name)
    Phoenix.HTML.FormData.to_form(changeset, as: "edit_task_form")
  end
end
