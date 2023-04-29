# Pair Dance

A tool to encourage and orchestrate pair programming.

## Pairing Domain

### Model

- User: a person who has logged in to pair.dance via SSO.
- Team: A group of team members.
- Member: a user associated with a team. 
- Task: Piece of work a team member is working on. May be linked to an entity in a backlog management tool (e.g. Jira, Pivotal Tracker).
- Assignment: An assignment links a member with a task.  

### Business rules

The Pair Dance consists of optimally allocating team members to tasks.

#### Teams
- All users can create unlimited number of teams.
- The user who created the team becomes its first member.
- Every team member can invite more people.

#### Assignments
- Any number of members can be assigned to a single task. A single member may be assigned to any number of tasks.

## Feature ideas

- Obtain tickets from Jira
- Allocations could happen off-platform on Slack
- Insights into pairing patterns can surface Retro conversations
- Tuple API to get actual allocations
- Their personal choice is taken into account where possible
- Knowledge is optimally shared among the team members
- Skills are applied and transferred
- Team members may have specialist areas but have worked an all aspects of the system

## Development

Check types:

```shell
mix dialyzer
```

Run tests:
```shell
mix test
```

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### Notes

- Associations between tables [tutorial](https://alchemist.camp/episodes/ecto-beginner-basic-associations)
- Set up seeds, e.g. like in [this project](https://github.com/space-rocket/Elixir-Phoenix-Foreign-Key-Example)

### Learn more about Phoenix

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
