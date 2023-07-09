defmodule PairDance.Domain.Team.TimeRangeTest do
  use PairDance.DataCase

  alias PairDance.Domain.Team.TimeRange

  describe "compare" do
    test "identical start and end" do
      time = ~U[2022-01-12 00:01:00.00Z]
      time_range = %TimeRange{start: time, end: time}

      assert TimeRange.compare(time_range, time_range) == true
    end

    test "identical start different end" do
      start = ~U[2022-01-12 00:01:00.00Z]
      end1 = ~U[2022-01-13 00:01:00.00Z]
      end2 = ~U[2022-01-14 00:01:00.00Z]
      time_range1 = %TimeRange{start: start, end: end1}
      time_range2 = %TimeRange{start: start, end: end2}

      assert TimeRange.compare(time_range1, time_range2) == true
      assert TimeRange.compare(time_range2, time_range1) == false
    end

    test "identical start both open ends" do
      start = ~U[2022-01-12 00:01:00.00Z]
      time_range1 = %TimeRange{start: start, end: nil}
      time_range2 = %TimeRange{start: start, end: nil}

      assert TimeRange.compare(time_range1, time_range2) == true
      assert TimeRange.compare(time_range2, time_range1) == true
    end

    test "identical start one open ends" do
      time = ~U[2022-01-12 00:01:00.00Z]
      time_range1 = %TimeRange{start: time, end: time}
      time_range2 = %TimeRange{start: time, end: nil}

      assert TimeRange.compare(time_range1, time_range2) == true
      assert TimeRange.compare(time_range2, time_range1) == false
    end

    test "one range inside the other" do
      wide = %TimeRange{start: ~U[2022-01-01 00:00:00.00Z], end: ~U[2022-01-04 00:00:00.00Z]}
      narrow = %TimeRange{start: ~U[2022-01-02 00:00:00.00Z], end: ~U[2022-01-03 00:00:00.00Z]}

      assert TimeRange.compare(wide, narrow) == false
      assert TimeRange.compare(narrow, wide) == true
    end

    test "earlier start open end" do
      wide = %TimeRange{start: ~U[2022-01-01 00:00:00.00Z], end: nil}
      narrow = %TimeRange{start: ~U[2022-01-02 00:00:00.00Z], end: ~U[2022-01-03 00:00:00.00Z]}

      assert TimeRange.compare(wide, narrow) == false
      assert TimeRange.compare(narrow, wide) == true
    end
  end
end
