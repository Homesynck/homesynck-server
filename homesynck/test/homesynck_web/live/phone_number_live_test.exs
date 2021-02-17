defmodule HomesynckWeb.PhoneNumberLiveTest do
  use HomesynckWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Homesynck.Auth

  @create_attrs %{expires_on: ~D[2010-04-17], number: "some number", register_token: "some register_token", verification_code: "some verification_code"}
  @update_attrs %{expires_on: ~D[2011-05-18], number: "some updated number", register_token: "some updated register_token", verification_code: "some updated verification_code"}
  @invalid_attrs %{expires_on: nil, number: nil, register_token: nil, verification_code: nil}

  defp fixture(:phone_number) do
    {:ok, phone_number} = Auth.create_phone_number(@create_attrs)
    phone_number
  end

  defp create_phone_number(_) do
    phone_number = fixture(:phone_number)
    %{phone_number: phone_number}
  end

  describe "Index" do
    setup [:create_phone_number]

    test "lists all phone_numbers", %{conn: conn, phone_number: phone_number} do
      {:ok, _index_live, html} = live(conn, Routes.phone_number_index_path(conn, :index))

      assert html =~ "Listing Phone numbers"
      assert html =~ phone_number.number
    end

    test "saves new phone_number", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.phone_number_index_path(conn, :index))

      assert index_live |> element("a", "New Phone number") |> render_click() =~
               "New Phone number"

      assert_patch(index_live, Routes.phone_number_index_path(conn, :new))

      assert index_live
             |> form("#phone_number-form", phone_number: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#phone_number-form", phone_number: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.phone_number_index_path(conn, :index))

      assert html =~ "Phone number created successfully"
      assert html =~ "some number"
    end

    test "updates phone_number in listing", %{conn: conn, phone_number: phone_number} do
      {:ok, index_live, _html} = live(conn, Routes.phone_number_index_path(conn, :index))

      assert index_live |> element("#phone_number-#{phone_number.id} a", "Edit") |> render_click() =~
               "Edit Phone number"

      assert_patch(index_live, Routes.phone_number_index_path(conn, :edit, phone_number))

      assert index_live
             |> form("#phone_number-form", phone_number: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#phone_number-form", phone_number: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.phone_number_index_path(conn, :index))

      assert html =~ "Phone number updated successfully"
      assert html =~ "some updated number"
    end

    test "deletes phone_number in listing", %{conn: conn, phone_number: phone_number} do
      {:ok, index_live, _html} = live(conn, Routes.phone_number_index_path(conn, :index))

      assert index_live |> element("#phone_number-#{phone_number.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#phone_number-#{phone_number.id}")
    end
  end

  describe "Show" do
    setup [:create_phone_number]

    test "displays phone_number", %{conn: conn, phone_number: phone_number} do
      {:ok, _show_live, html} = live(conn, Routes.phone_number_show_path(conn, :show, phone_number))

      assert html =~ "Show Phone number"
      assert html =~ phone_number.number
    end

    test "updates phone_number within modal", %{conn: conn, phone_number: phone_number} do
      {:ok, show_live, _html} = live(conn, Routes.phone_number_show_path(conn, :show, phone_number))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Phone number"

      assert_patch(show_live, Routes.phone_number_show_path(conn, :edit, phone_number))

      assert show_live
             |> form("#phone_number-form", phone_number: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#phone_number-form", phone_number: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.phone_number_show_path(conn, :show, phone_number))

      assert html =~ "Phone number updated successfully"
      assert html =~ "some updated number"
    end
  end
end
