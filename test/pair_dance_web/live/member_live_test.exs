defmodule PairDanceWeb.MemberLiveTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_member(_) do
    team = team_fixture()
    member = member_fixture(%{:team_id => team.id, :name => "Alice"})
    %{member: member}
  end

  describe "Index" do
    setup [:create_member]

    test "lists all members", %{conn: conn, member: member} do
      {:ok, _index_live, html} = live(conn, ~p"/members")

      assert html =~ "Listing Members"
      assert html =~ member.name
    end

    test "saves new member", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/members")

      assert index_live |> element("a", "New Member") |> render_click() =~
               "New Member"

      assert_patch(index_live, ~p"/members/new")

      assert index_live
             |> form("#member-form", member: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      a_team = team_fixture()
      valid_member = %{name: "some name", team_id: a_team.id}

      {:ok, _, html} =
        index_live
        |> form("#member-form", member: valid_member)
        |> render_submit()
        |> follow_redirect(conn, ~p"/members")

      assert html =~ "Member created successfully"
      assert html =~ "some name"
    end

    test "updates member in listing", %{conn: conn, member: member} do
      {:ok, index_live, _html} = live(conn, ~p"/members")

      assert index_live |> element("#members-#{member.id} a", "Edit") |> render_click() =~
               "Edit Member"

      assert_patch(index_live, ~p"/members/#{member}/edit")

      assert index_live
             |> form("#member-form", member: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#member-form", member: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/members")

      assert html =~ "Member updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes member in listing", %{conn: conn, member: member} do
      {:ok, index_live, _html} = live(conn, ~p"/members")

      assert index_live |> element("#members-#{member.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#member-#{member.id}")
    end
  end

  describe "Show" do
    setup [:create_member]

    test "displays member", %{conn: conn, member: member} do
      {:ok, _show_live, html} = live(conn, ~p"/members/#{member}")

      assert html =~ "Show Member"
      assert html =~ member.name
    end

    test "updates member within modal", %{conn: conn, member: member} do
      {:ok, show_live, _html} = live(conn, ~p"/members/#{member}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Member"

      assert_patch(show_live, ~p"/members/#{member}/show/edit")

      assert show_live
             |> form("#member-form", member: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#member-form", member: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/members/#{member}")

      assert html =~ "Member updated successfully"
      assert html =~ "some updated name"
    end
  end
end
