# Pair Dance

[![Pair Dance CI status](https://circleci.com/gh/TresAmigosLtd/pair_dance.svg?style=svg)](https://app.circleci.com/pipelines/github/TresAmigosLtd/pair_dance)

A tool to elevate pair programming by making pair rotations smooth and effective.

## Pairing Domain

### Model

- **User**: Entity, a person who has logged in to pair.dance via SSO. Can be a member of multiple teams.
- **Member**: Entity, a user associated with a team.
- **Task**: Entity, for a piece of work a team member is working on. May be linked to an entity in a backlog management
  tool (e.g. Jira, Pivotal Tracker).
- **Assignment**: Value obejct, links a member with a task.
- **Team**: Aggregate root linking: members, tasks and assignment. Has also a name and a slug.

### Business rules

#### Teams

- All users can create unlimited number of teams.
- The user who created the team becomes its first member.
- Every team member can invite more people.

#### Assignments

- Any number of members can be assigned to a single task. A single member may be assigned to any number of tasks.

## Feature ideas

- Allocations could happen on Slack
- Insights into pairing patterns can surface Retro conversations
- Use Tuple API to get actual allocations
- Use Google Calendar API to prevent pairing allocations which are unrealistic due to overlapping calendars

## Development

Initial setup:

- Assumes you have a pre M(1,2.3) Mac and brew

> ⚠️ Setup does not support MM(1,2.3)s. Contributions welcome!

```
./setup
```

Check types:

```shell
mix dialyzer
```

Run tests:

```shell
mix test
mix test.e2e
```

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Install latest phx:

```
mix archive.install hex phx_new
```

### Notes

- Associations between tables [tutorial](https://alchemist.camp/episodes/ecto-beginner-basic-associations)
- Set up seeds, e.g. like in [this project](https://github.com/space-rocket/Elixir-Phoenix-Foreign-Key-Example)

### CI insights

[![CircleCI](https://dl.circleci.com/insights-snapshot/gh/TresAmigosLtd/pair_dance/main/build/badge.svg?window=30d)](https://app.circleci.com/insights/github/TresAmigosLtd/pair_dance/workflows/build/overview?branch=main&reporting-window=last-30-days&insights-snapshot=true)

### Learn more about Phoenix

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
- Components: https://hexdocs.pm/phoenix/1.7.0-rc.0/components.html
- Live Components: https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html
