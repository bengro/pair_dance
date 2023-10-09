defmodule PairDance.Infrastructure.EventBus do
  @updated_team_topic "updated_team"

  def broadcast(team_id, payload) do
    Phoenix.PubSub.broadcast(PairDance.PubSub, "#{@updated_team_topic}:#{team_id}", payload)
  end

  def subscribe(team_id) do
    Phoenix.PubSub.subscribe(PairDance.PubSub, "#{@updated_team_topic}:#{team_id}")
  end
end
