defmodule PairDance.Infrastructure.Integrations.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "integrations" do
    field :settings, PairDance.Infrastructure.Encrypted.Map

    timestamps()
  end

  @doc false
  def changeset(integration, attrs) do
    integration
    |> cast(attrs, [:settings])
  end
end
