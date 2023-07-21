defmodule PairDance.Infrastructure.EventBus do
  @updated_team_topic "updated_team"

  def broadcast(payload) do
    Phoenix.PubSub.broadcast(PairDance.PubSub, @updated_team_topic, payload)
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(PairDance.PubSub, @updated_team_topic)
  end
end
