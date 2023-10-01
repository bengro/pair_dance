defmodule PairDance.Infrastructure.Integrations.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "integrations" do
    belongs_to(:team, PairDance.Infrastructure.TeamEntity)
    field :settings, PairDance.Infrastructure.Encrypted.Map

    timestamps()
  end

  @doc false
  def changeset(integration, attrs) do
    integration
    |> cast(attrs, [:team_id, :settings])
  end
end
