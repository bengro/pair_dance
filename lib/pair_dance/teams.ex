defmodule PairDance.Teams do

  import Ecto.Query, warn: false
  alias PairDance.Infrastructure.Repo

  alias PairDance.Teams.Task

  def get_task!(id), do: Repo.get!(Task, id)

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  def list_all_tasks do
    Repo.all(Task)
  end

  def list_tasks(team_id) do
    Repo.all from t in Task, where: t.team_id == ^team_id
  end
end
