defmodule PairDance.Domain.Insights.Report do
  def generate_report(all_assignments) do
    all_tasks = all_assignments |> Enum.map(fn assignment -> assignment.task end) |> Enum.uniq()

    all_assignments
    |> Enum.group_by(fn assignment -> assignment.task.id end)
    |> Enum.map(fn {task_id, assignments} ->
      task = all_tasks |> Enum.find(fn x -> x.id == task_id end)
      calculate(task, assignments)
    end)
  end

  defp calculate(task, assignments) do
    sorted_assignments = assignments |> Enum.sort_by(fn assignment -> assignment.time_range end)

    if length(assignments) == 1 do
      aggregate_findings(task, [], [Enum.at(assignments, 0).member])
    else
      findings =
        sorted_assignments
        |> Enum.with_index()
        |> Enum.reduce(%{pairings: [], involved_members: []}, fn {t1, index}, acc ->
          other_assignments = sublist(sorted_assignments, index)

          case length(other_assignments) do
            0 ->
              acc

            _ ->
              pairings = extract_pairings(t1, other_assignments)
              involved_members = extract_members(t1, other_assignments)

              %{
                pairings: acc.pairings ++ pairings,
                involved_members: (acc.involved_members ++ involved_members) |> Enum.uniq()
              }
          end
        end)

      aggregate_findings(
        task,
        findings.pairings,
        findings.involved_members
      )
    end
  end

  defp extract_members(t1, assignments) do
    Enum.reduce(assignments, [], fn t2, acc ->
      Enum.uniq([t1.member, t2.member | acc])
    end)
  end

  defp extract_pairings(t1, assignments) do
    Enum.reduce(assignments, [], fn t2, acc ->
      if is_overlap(t1, t2) do
        [{t1.member.id, t2.member.id} | acc]
      else
        acc
      end
    end)
  end

  # Returns a sublist of a list, excluding the first element.
  defp sublist(list, index) do
    assignment_count = length(list)
    max_index = assignment_count - 1

    Enum.slice(
      list,
      min(assignment_count, index + 1),
      max_index
    )
  end

  defp aggregate_findings(task, member_pairings, members) do
    %{
      task: task,
      member_pairings: member_pairings,
      members: members
    }
  end

  defp is_overlap(a1, a2) do
    a1_start = DateTime.to_unix(a1.time_range.start)

    a1_end =
      DateTime.to_unix(
        if a1.time_range.end == nil, do: DateTime.utc_now(), else: a1.time_range.end
      )

    a2_start = DateTime.to_unix(a2.time_range.start)

    a2_end =
      DateTime.to_unix(
        if a2.time_range.end == nil, do: DateTime.utc_now(), else: a2.time_range.end
      )

    a1_start <= a2_end && a2_start <= a1_end
  end
end
