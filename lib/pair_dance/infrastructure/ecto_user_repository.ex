defmodule PairDance.Infrastructure.EctoUserRepository do

  alias PairDance.Domain.UserRepository

  alias PairDance.Infrastructure.UserEntity

  import Ecto.Query, warn: false
  alias PairDance.Repo

  import PairDance.Infrastructure.EntityConverters

  @behaviour UserRepository

  @impl UserRepository
  def create_from_email(email) do
    result = %UserEntity{}
      |> UserEntity.changeset(%{ email: email })
      |> Repo.insert()
    case result do
      {:ok, entity} -> {:ok, to_user(entity)}
      {:error, %Ecto.Changeset{ errors: [ {:email, {_,[{:constraint, :unique},_]}} ]}} -> {:error, {:conflict, "email address already taken"}}
    end
  end

  @impl UserRepository
  def find_by_email_or_create(email) do
    case create_from_email(email) do
      {:ok, user} -> user
      {:error, {:conflict, _}} -> find_by_email(email)
    end
  end

  @impl UserRepository
  def find_by_id(id) do
    case Repo.get(UserEntity, id) do
      nil -> nil
      entity -> to_user(entity)
    end
  end

  @impl UserRepository
  def find_by_email(email) do
    case Repo.one from u in UserEntity, where: u.email == ^email do
      nil -> nil
      entity -> to_user(entity)
    end
  end

  @impl UserRepository
  def find_all() do
    Repo.all(UserEntity) |> Enum.map(&to_user/1)
  end

  @impl UserRepository
  def delete_by_id(id) do
    {:ok, _entity} = Repo.delete(%UserEntity{ id: id })
    {:ok}
  end

end
