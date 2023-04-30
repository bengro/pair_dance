defmodule PairDance.Infrastructure.EctoUserRepository do

  alias PairDance.Domain.UserRepository
  alias PairDance.Domain.User

  alias PairDance.Infrastructure.UserEntity

  import Ecto.Query, warn: false
  alias PairDance.Repo

  @behaviour UserRepository

  @impl UserRepository
  def create(name) do
    {:ok, entity } = %UserEntity{}
      |> UserEntity.changeset(%{ name: name })
      |> Repo.insert()
    {:ok, from_entity(entity)}
  end

  @impl UserRepository
  def find(id) do
    case Repo.get(UserEntity, id) do
      nil -> nil
      entity -> from_entity(entity)
    end
  end

  @spec from_entity(UserEntity) :: User.t()
  defp from_entity(entity) do
    %User{ id: entity.id, name: entity.name }
  end

end
