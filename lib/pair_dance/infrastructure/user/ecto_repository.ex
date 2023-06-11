defmodule PairDance.Infrastructure.User.EctoRepository do
  alias PairDance.Domain.User

  alias PairDance.Infrastructure.User.Entity

  import Ecto.Query, warn: false
  alias PairDance.Infrastructure.Repo

  import PairDance.Infrastructure.EntityConverters

  @behaviour User.Repository

  @impl User.Repository
  def create_from_email(email) do
    result =
      %Entity{}
      |> Entity.changeset(%{email: email})
      |> Repo.insert()

    case result do
      {:ok, entity} ->
        {:ok, to_user(entity)}

      {:error, %Ecto.Changeset{errors: [{:email, {_, [{:constraint, :unique}, _]}}]}} ->
        {:error, {:conflict, "email address already taken"}}
    end
  end

  @impl User.Repository
  def find_by_email_or_create(email) do
    case create_from_email(email) do
      {:ok, user} -> user
      {:error, {:conflict, _}} -> find_by_email(email)
    end
  end

  @impl User.Repository
  def find_by_id(id) do
    case Repo.get(Entity, id) do
      nil -> nil
      entity -> to_user(entity)
    end
  end

  @impl User.Repository
  def find_by_email(email) do
    case Repo.one(from u in Entity, where: u.email == ^email) do
      nil -> nil
      entity -> to_user(entity)
    end
  end

  @impl User.Repository
  def find_all() do
    Repo.all(Entity) |> Enum.map(&to_user/1)
  end

  @impl User.Repository
  def delete_by_id(id) do
    {:ok, _entity} = Repo.delete(%Entity{id: id})
    {:ok}
  end

  @impl User.Repository
  def update(user, patch) do
    entity = %Entity{id: user.id, email: user.email}

    case Entity.changeset(entity, patch) |> Repo.update() do
      {:ok, entity} -> {:ok, to_user(entity)}
    end
  end
end
