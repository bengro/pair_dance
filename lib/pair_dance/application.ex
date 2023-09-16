defmodule PairDance.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PairDanceWeb.Telemetry,
      # Start the Ecto repository
      PairDance.Infrastructure.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PairDance.PubSub},
      # Start Finch
      {Finch, name: PairDance.Finch},
      # Start the Endpoint (http/https)
      PairDanceWeb.Endpoint,
      # Start a worker by calling: PairDance.Worker.start_link(arg)
      # {PairDance.Worker, arg}
      PairDance.Infrastructure.Encrypted.Vault
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PairDance.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PairDanceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
