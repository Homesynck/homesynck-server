defmodule HomesynckWeb.ControllerLiveTest do
  use HomesynckWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Homesynck.Sync

  @create_attrs %{last_online: ~D[2010-04-17], name: "some name"}
  @update_attrs %{last_online: ~D[2011-05-18], name: "some updated name"}
  @invalid_attrs %{last_online: nil, name: nil}

  defp fixture(:controller) do
    {:ok, controller} = Sync.create_controller(@create_attrs)
    controller
  end

  defp create_controller(_) do
    controller = fixture(:controller)
    %{controller: controller}
  end

  describe "Index" do
    setup [:create_controller]

    test "lists all controllers", %{conn: conn, controller: controller} do
      {:ok, _index_live, html} = live(conn, Routes.controller_index_path(conn, :index))

      assert html =~ "Listing Controllers"
      assert html =~ controller.name
    end

    test "saves new controller", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.controller_index_path(conn, :index))

      assert index_live |> element("a", "New Controller") |> render_click() =~
               "New Controller"

      assert_patch(index_live, Routes.controller_index_path(conn, :new))

      assert index_live
             |> form("#controller-form", controller: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#controller-form", controller: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.controller_index_path(conn, :index))

      assert html =~ "Controller created successfully"
      assert html =~ "some name"
    end

    test "updates controller in listing", %{conn: conn, controller: controller} do
      {:ok, index_live, _html} = live(conn, Routes.controller_index_path(conn, :index))

      assert index_live |> element("#controller-#{controller.id} a", "Edit") |> render_click() =~
               "Edit Controller"

      assert_patch(index_live, Routes.controller_index_path(conn, :edit, controller))

      assert index_live
             |> form("#controller-form", controller: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#controller-form", controller: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.controller_index_path(conn, :index))

      assert html =~ "Controller updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes controller in listing", %{conn: conn, controller: controller} do
      {:ok, index_live, _html} = live(conn, Routes.controller_index_path(conn, :index))

      assert index_live |> element("#controller-#{controller.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#controller-#{controller.id}")
    end
  end

  describe "Show" do
    setup [:create_controller]

    test "displays controller", %{conn: conn, controller: controller} do
      {:ok, _show_live, html} = live(conn, Routes.controller_show_path(conn, :show, controller))

      assert html =~ "Show Controller"
      assert html =~ controller.name
    end

    test "updates controller within modal", %{conn: conn, controller: controller} do
      {:ok, show_live, _html} = live(conn, Routes.controller_show_path(conn, :show, controller))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Controller"

      assert_patch(show_live, Routes.controller_show_path(conn, :edit, controller))

      assert show_live
             |> form("#controller-form", controller: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#controller-form", controller: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.controller_show_path(conn, :show, controller))

      assert html =~ "Controller updated successfully"
      assert html =~ "some updated name"
    end
  end
end
