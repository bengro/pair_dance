defmodule PairDance.TeamsFixtures do

  alias PairDance.Domain.User
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task

  alias PairDance.Infrastructure.EctoUserRepository, as: UserRepository
  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository
  alias PairDance.Domain.Team.InviteService

  @type email :: String.t

  @spec user_fixture(email()) :: User.t()
  def user_fixture(email \\ "me@hello.com") do
    {:ok, user} = UserRepository.create_from_email(email)
    user
  end

  def team_fixture(name \\ "some name") do
    {:ok, team} = TeamRepository.create(name)
    team
  end

  @spec member_fixture(Team.t(), String.t()) :: Member.t()
  def member_fixture(team, email \\ "bob@me.com") do
    %Team{ members: members } = InviteService.invite(team, email)
    Enum.find(members, fn m -> m.user.email == email end)
  end

  @spec task_fixture(Team.t(), String.t()) :: Task.t()
  def task_fixture(team, task_name \\ "logout is broken") do
    {:ok, updated_team} = TeamRepository.add_task(team, task_name)
    Enum.find(updated_team.tasks, fn t -> t.name == task_name end)
  end
end
