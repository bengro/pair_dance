defmodule PairDance.Domain.Team.TimeRangeTest do
  use PairDance.DataCase

  alias PairDance.Domain.Team.TimeRange

  describe "compare" do
    test "identical start and end" do
      time = ~U[2022-01-12 00:01:00.00Z]
      time_range = %TimeRange{start: time, end: time}

      assert TimeRange.compare(time_range, time_range) == :eq
    end

    test "identical start different end" do
      start = ~U[2022-01-12 00:01:00.00Z]
      end1 = ~U[2022-01-13 00:01:00.00Z]
      end2 = ~U[2022-01-14 00:01:00.00Z]
      time_range1 = %TimeRange{start: start, end: end1}
      time_range2 = %TimeRange{start: start, end: end2}

      assert TimeRange.compare(time_range1, time_range2) == :lt
      assert TimeRange.compare(time_range2, time_range1) == :gt
    end

    test "identical start both open ends" do
      start = ~U[2022-01-12 00:01:00.00Z]
      time_range1 = %TimeRange{start: start, end: nil}
      time_range2 = %TimeRange{start: start, end: nil}

      assert TimeRange.compare(time_range1, time_range2) == :eq
      assert TimeRange.compare(time_range2, time_range1) == :eq
    end

    test "identical start one open ends" do
      time = ~U[2022-01-12 00:01:00.00Z]
      time_range1 = %TimeRange{start: time, end: time}
      time_range2 = %TimeRange{start: time, end: nil}

      assert TimeRange.compare(time_range1, time_range2) == :lt
      assert TimeRange.compare(time_range2, time_range1) == :gt
    end

    test "one range inside the other" do
      wide = %TimeRange{start: ~U[2022-01-01 00:00:00.00Z], end: ~U[2022-01-04 00:00:00.00Z]}
      narrow = %TimeRange{start: ~U[2022-01-02 00:00:00.00Z], end: ~U[2022-01-03 00:00:00.00Z]}

      assert TimeRange.compare(wide, narrow) == :gt
      assert TimeRange.compare(narrow, wide) == :lt
    end

    test "earlier start open end" do
      wide = %TimeRange{start: ~U[2022-01-01 00:00:00.00Z], end: nil}
      narrow = %TimeRange{start: ~U[2022-01-02 00:00:00.00Z], end: ~U[2022-01-03 00:00:00.00Z]}

      assert TimeRange.compare(wide, narrow) == :gt
      assert TimeRange.compare(narrow, wide) == :lt
    end
  end

  describe "merge" do
    test "complete time ranges" do
      wide = %TimeRange{start: ~U[2022-01-01 00:00:00.00Z], end: ~U[2022-01-04 00:00:00.00Z]}
      narrow = %TimeRange{start: ~U[2022-01-02 00:00:00.00Z], end: ~U[2022-01-03 00:00:00.00Z]}

      assert TimeRange.merge([wide, narrow]) == wide
      assert TimeRange.merge([narrow, wide]) == wide
    end

    test "open time ranges" do
      closed = %TimeRange{start: ~U[2022-01-01 00:00:00.00Z], end: ~U[2022-01-04 00:00:00.00Z]}
      open = %TimeRange{start: ~U[2022-01-02 00:00:00.00Z], end: nil}

      assert TimeRange.merge([closed, open]).end == nil
      assert TimeRange.merge([open, closed]).end == nil
    end
  end
end
