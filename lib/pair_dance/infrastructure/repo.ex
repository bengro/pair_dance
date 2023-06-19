defmodule PairDance.Infrastructure.Repo do
  use Ecto.Repo,
    otp_app: :pair_dance,
    adapter: Ecto.Adapters.Postgres

  use Ecto.SoftDelete.Repo
end
