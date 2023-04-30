defmodule PairDance.Infrastructure.EctoUserRepository do

  alias PairDance.Domain.UserRepository
  alias PairDance.Domain.User

  alias PairDance.Infrastructure.UserEntity

  import Ecto.Query, warn: false
  alias PairDance.Repo

  @behaviour UserRepository

  @impl UserRepository
  def create(email) do
    result = %UserEntity{}
      |> UserEntity.changeset(%{ email: email })
      |> Repo.insert()
    case result do
      {:ok, entity} -> {:ok, from_entity(entity)}
      {:error, %Ecto.Changeset{ errors: [ {:email, {err, _}} ]}} -> {:error, err}
    end
  end

  @impl UserRepository
  def find_by_id(id) do
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
    %User{ id: entity.id, email: entity.email }
  end

end
