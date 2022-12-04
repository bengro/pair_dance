defmodule PairDance.Repo do
  use Ecto.Repo,
    otp_app: :pair_dance,
    adapter: Ecto.Adapters.Postgres
end
