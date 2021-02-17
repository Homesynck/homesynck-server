defmodule HomesynckWeb.UpdateReceivedLiveTest do
  use HomesynckWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Homesynck.Sync

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:update_received) do
    {:ok, update_received} = Sync.create_update_received(@create_attrs)
    update_received
  end

  defp create_update_received(_) do
    update_received = fixture(:update_received)
    %{update_received: update_received}
  end

  describe "Index" do
    setup [:create_update_received]

    test "lists all updates_received", %{conn: conn, update_received: update_received} do
      {:ok, _index_live, html} = live(conn, Routes.update_received_index_path(conn, :index))

      assert html =~ "Listing Updates received"
    end

    test "saves new update_received", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.update_received_index_path(conn, :index))

      assert index_live |> element("a", "New Update received") |> render_click() =~
               "New Update received"

      assert_patch(index_live, Routes.update_received_index_path(conn, :new))

      assert index_live
             |> form("#update_received-form", update_received: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#update_received-form", update_received: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.update_received_index_path(conn, :index))

      assert html =~ "Update received created successfully"
    end

    test "updates update_received in listing", %{conn: conn, update_received: update_received} do
      {:ok, index_live, _html} = live(conn, Routes.update_received_index_path(conn, :index))

      assert index_live |> element("#update_received-#{update_received.id} a", "Edit") |> render_click() =~
               "Edit Update received"

      assert_patch(index_live, Routes.update_received_index_path(conn, :edit, update_received))

      assert index_live
             |> form("#update_received-form", update_received: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#update_received-form", update_received: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.update_received_index_path(conn, :index))

      assert html =~ "Update received updated successfully"
    end

    test "deletes update_received in listing", %{conn: conn, update_received: update_received} do
      {:ok, index_live, _html} = live(conn, Routes.update_received_index_path(conn, :index))

      assert index_live |> element("#update_received-#{update_received.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#update_received-#{update_received.id}")
    end
  end

  describe "Show" do
    setup [:create_update_received]

    test "displays update_received", %{conn: conn, update_received: update_received} do
      {:ok, _show_live, html} = live(conn, Routes.update_received_show_path(conn, :show, update_received))

      assert html =~ "Show Update received"
    end

    test "updates update_received within modal", %{conn: conn, update_received: update_received} do
      {:ok, show_live, _html} = live(conn, Routes.update_received_show_path(conn, :show, update_received))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Update received"

      assert_patch(show_live, Routes.update_received_show_path(conn, :edit, update_received))

      assert show_live
             |> form("#update_received-form", update_received: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#update_received-form", update_received: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.update_received_show_path(conn, :show, update_received))

      assert html =~ "Update received updated successfully"
    end
  end
end
