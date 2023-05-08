defmodule PairDance.Teams do

  import Ecto.Query, warn: false
  alias PairDance.Infrastructure.Repo

  alias PairDance.Teams.TaskEntity

  def get_task!(id), do: Repo.get!(TaskEntity, id)

  def change_task(%TaskEntity{} = task, attrs \\ %{}) do
    TaskEntity.changeset(task, attrs)
  end

  def update_task(%TaskEntity{} = task, attrs) do
    task
    |> TaskEntity.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%TaskEntity{} = task) do
    Repo.delete(task)
  end

  def list_all_tasks do
    Repo.all(TaskEntity)
  end

  def list_tasks(team_id) do
    Repo.all from t in TaskEntity, where: t.team_id == ^team_id
  end
end
