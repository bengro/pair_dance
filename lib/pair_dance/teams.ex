defmodule PairDance.Teams do

  import Ecto.Query, warn: false
  alias PairDance.Repo

  alias PairDance.Teams.Team
  alias PairDance.Teams.Member
  alias PairDance.Teams.Task
  alias PairDance.Teams.TaskOwnership

  def change_team(%Team{} = team, attrs) do
    Team.changeset(team, attrs)
  end

  def change_team(%PairDance.Domain.Team{} = team, attrs) do
    Team.changeset(%Team{ name: team.name, id: team.id }, attrs)
  end

  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  def change_member(%Member{} = member, attrs \\ %{}) do
    Member.changeset(member, attrs)
  end

  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  def get_member!(id), do: Repo.get!(Member, id)

  def list_all_members do
    Repo.all(Member)
  end

  def list_members(team_id) do
    Repo.all from m in Member, where: m.team_id == ^team_id
  end

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

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

  def create_ownership(%Task{} = task, %Member{} = member) do
    TaskOwnership.changeset(%TaskOwnership{ task_id: task.id, member_id: member.id }, %{})
    |> Repo.insert()
  end

  def remove_ownership(%Task{} = task, %Member{} = member) do
    member_id = member.id
    Repo.delete_all from to in TaskOwnership, where: to.member_id == ^member_id
  end

  def list_ownerships(team_id) do
    Repo.all from m in Member,
             join: to in TaskOwnership,
             on: to.member_id == m.id,
             where: m.team_id == ^team_id,
             select: to
  end
end
