defmodule HomesynckWeb.UpdateLiveTest do
  use HomesynckWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Homesynck.Sync

  @create_attrs %{instructions: "some instructions", rank: 42}
  @update_attrs %{instructions: "some updated instructions", rank: 43}
  @invalid_attrs %{instructions: nil, rank: nil}

  defp fixture(:update) do
    {:ok, update} = Sync.create_update(@create_attrs)
    update
  end

  defp create_update(_) do
    update = fixture(:update)
    %{update: update}
  end

  describe "Index" do
    setup [:create_update]

    test "lists all updates", %{conn: conn, update: update} do
      {:ok, _index_live, html} = live(conn, Routes.update_index_path(conn, :index))

      assert html =~ "Listing Updates"
      assert html =~ update.instructions
    end

    test "saves new update", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.update_index_path(conn, :index))

      assert index_live |> element("a", "New Update") |> render_click() =~
               "New Update"

      assert_patch(index_live, Routes.update_index_path(conn, :new))

      assert index_live
             |> form("#update-form", update: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#update-form", update: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.update_index_path(conn, :index))

      assert html =~ "Update created successfully"
      assert html =~ "some instructions"
    end

    test "updates update in listing", %{conn: conn, update: update} do
      {:ok, index_live, _html} = live(conn, Routes.update_index_path(conn, :index))

      assert index_live |> element("#update-#{update.id} a", "Edit") |> render_click() =~
               "Edit Update"

      assert_patch(index_live, Routes.update_index_path(conn, :edit, update))

      assert index_live
             |> form("#update-form", update: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#update-form", update: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.update_index_path(conn, :index))

      assert html =~ "Update updated successfully"
      assert html =~ "some updated instructions"
    end

    test "deletes update in listing", %{conn: conn, update: update} do
      {:ok, index_live, _html} = live(conn, Routes.update_index_path(conn, :index))

      assert index_live |> element("#update-#{update.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#update-#{update.id}")
    end
  end

  describe "Show" do
    setup [:create_update]

    test "displays update", %{conn: conn, update: update} do
      {:ok, _show_live, html} = live(conn, Routes.update_show_path(conn, :show, update))

      assert html =~ "Show Update"
      assert html =~ update.instructions
    end

    test "updates update within modal", %{conn: conn, update: update} do
      {:ok, show_live, _html} = live(conn, Routes.update_show_path(conn, :show, update))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Update"

      assert_patch(show_live, Routes.update_show_path(conn, :edit, update))

      assert show_live
             |> form("#update-form", update: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#update-form", update: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.update_show_path(conn, :show, update))

      assert html =~ "Update updated successfully"
      assert html =~ "some updated instructions"
    end
  end
end
