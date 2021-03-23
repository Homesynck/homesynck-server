defmodule Homesynck.AuthTest do
  use Homesynck.DataCase

  alias Homesynck.Auth

  describe "users" do
    alias Homesynck.Auth.User

    @valid_attrs %{
      email: "some email",
      name: "some name",
      password_hashed: "some password_hashed"
    }
    @update_attrs %{
      email: "some updated email",
      name: "some updated name",
      password_hashed: "some updated password_hashed"
    }
    @invalid_attrs %{email: nil, name: nil, password_hashed: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.password_hashed == "some password_hashed"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.password_hashed == "some updated password_hashed"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end

  describe "phone_numbers" do
    alias Homesynck.Auth.PhoneNumber

    @valid_attrs %{
      expires_on: ~D[2010-04-17],
      number: "some number",
      register_token: "some register_token",
      verification_code: "some verification_code"
    }
    @update_attrs %{
      expires_on: ~D[2011-05-18],
      number: "some updated number",
      register_token: "some updated register_token",
      verification_code: "some updated verification_code"
    }
    @invalid_attrs %{expires_on: nil, number: nil, register_token: nil, verification_code: nil}

    def phone_number_fixture(attrs \\ %{}) do
      {:ok, phone_number} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_phone_number()

      phone_number
    end

    test "list_phone_numbers/0 returns all phone_numbers" do
      phone_number = phone_number_fixture()
      assert Auth.list_phone_numbers() == [phone_number]
    end

    test "get_phone_number!/1 returns the phone_number with given id" do
      phone_number = phone_number_fixture()
      assert Auth.get_phone_number!(phone_number.id) == phone_number
    end

    test "create_phone_number/1 with valid data creates a phone_number" do
      assert {:ok, %PhoneNumber{} = phone_number} = Auth.create_phone_number(@valid_attrs)
      assert phone_number.expires_on == ~D[2010-04-17]
      assert phone_number.number == "some number"
      assert phone_number.register_token == "some register_token"
      assert phone_number.verification_code == "some verification_code"
    end

    test "create_phone_number/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_phone_number(@invalid_attrs)
    end

    test "update_phone_number/2 with valid data updates the phone_number" do
      phone_number = phone_number_fixture()

      assert {:ok, %PhoneNumber{} = phone_number} =
               Auth.update_phone_number(phone_number, @update_attrs)

      assert phone_number.expires_on == ~D[2011-05-18]
      assert phone_number.number == "some updated number"
      assert phone_number.register_token == "some updated register_token"
      assert phone_number.verification_code == "some updated verification_code"
    end

    test "update_phone_number/2 with invalid data returns error changeset" do
      phone_number = phone_number_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_phone_number(phone_number, @invalid_attrs)
      assert phone_number == Auth.get_phone_number!(phone_number.id)
    end

    test "delete_phone_number/1 deletes the phone_number" do
      phone_number = phone_number_fixture()
      assert {:ok, %PhoneNumber{}} = Auth.delete_phone_number(phone_number)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_phone_number!(phone_number.id) end
    end

    test "change_phone_number/1 returns a phone_number changeset" do
      phone_number = phone_number_fixture()
      assert %Ecto.Changeset{} = Auth.change_phone_number(phone_number)
    end
  end
end
