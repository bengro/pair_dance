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

  @impl UserRepository
  def find_all() do
    Repo.all(UserEntity) |> Enum.map(&from_entity/1)
  end

  @impl UserRepository
  def delete(id) do
    {:ok, _entity} = Repo.delete(%UserEntity{ id: id })
    {:ok}
  end

  @spec from_entity(UserEntity) :: User.t()
  defp from_entity(entity) do
    %User{ id: entity.id, name: entity.name }
  end

end
