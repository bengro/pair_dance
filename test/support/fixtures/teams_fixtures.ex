defmodule PairDance.TeamsFixtures do
  alias PairDance.Domain.User
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task

  alias PairDance.Infrastructure.User.EctoRepository, as: UserRepository
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Domain.Team.InviteService

  @type email :: String.t()

  @spec user_fixture(email()) :: User.t()
  def user_fixture(email \\ "me@hello.com") do
    {:ok, user} = UserRepository.create_from_email(email)
    user
  end

  def team_fixture(name \\ "some name") do
    {:ok, team} = TeamRepository.create(name)
    team
  end

  def create_team(%{member_names: member_names, task_names: task_names}) do
    {:ok, team} = TeamRepository.create("Team Comet")

    Enum.each(member_names, fn name ->
      email = name <> "@test.com"
      user = UserRepository.find_by_email_or_create(email)
      UserRepository.update(user, %{name: name})
      member_fixture(team, email)
    end)

    Enum.each(task_names, fn task_name -> TeamRepository.add_task(team, task_name) end)

    TeamRepository.find(team.id)
  end

  def create_assignment(team, task_name, member_name) do
    task = Enum.find(team.tasks, fn task -> task.name == task_name end)
    member = Enum.find(team.members, fn member -> member.user.name == member_name end)

    {:ok, team} = TeamRepository.assign_member_to_task(team, member, task)

    team
  end

  def delete_assignment(team, task_name, member_name) do
    assignment =
      Enum.find(team.assignments, fn assignment ->
        assignment.task.name == task_name && assignment.member.user.name == member_name
      end)

    {:ok, team} =
      TeamRepository.unassign_member_from_task(team, assignment.member, assignment.task)

    team
  end

  @spec member_fixture(Team.t(), String.t()) :: Member.t()
  def member_fixture(team, email \\ "bob@me.com") do
    %Team{members: members} = InviteService.invite(team, email)
    Enum.find(members, fn m -> m.user.email == email end)
  end

  @spec task_fixture(Team.t(), String.t()) :: Task.t()
  def task_fixture(team, task_name \\ "logout is broken") do
    {:ok, updated_team} = TeamRepository.add_task(team, task_name)
    Enum.find(updated_team.tasks, fn t -> t.name == task_name end)
  end
end
