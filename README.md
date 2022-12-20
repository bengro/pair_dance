# Pair Dance

A tool to encourage and orchestrate pair programming.

## Pairing Domain

### Model

- Team: A team has a name and consists of team members
- Team member: Has a name, and potentially an email
- Task: Piece of work a team member is working on
- Allocation: A configuration of team members and tasks

### Business rules

The Pair Dance consists of optimally allocating team members to tasks such that:

- Their personal choice is taken into account where possible
- Knowledge is optimally shared among the team members
- Skills are applied and transferred
- Team members may have specialist areas but have worked an all aspects of the system

## Feature ideas

- Obtain tickets from Jira
- Allocations could happen off-platform on Slack
- Insights into pairing patterns can surface Retro conversations
- Tuple API to get actual allocations

## Development

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### Learn more about Phoenix

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
