defmodule Homesynck.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Homesynck.Repo

  alias Homesynck.Auth.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias Homesynck.Auth.PhoneNumber

  @doc """
  Returns the list of phone_numbers.

  ## Examples

      iex> list_phone_numbers()
      [%PhoneNumber{}, ...]

  """
  def list_phone_numbers do
    Repo.all(PhoneNumber)
  end

  @doc """
  Gets a single phone_number.

  Raises `Ecto.NoResultsError` if the Phone number does not exist.

  ## Examples

      iex> get_phone_number!(123)
      %PhoneNumber{}

      iex> get_phone_number!(456)
      ** (Ecto.NoResultsError)

  """
  def get_phone_number!(id), do: Repo.get!(PhoneNumber, id)

  @doc """
  Creates a phone_number.

  ## Examples

      iex> create_phone_number(%{field: value})
      {:ok, %PhoneNumber{}}

      iex> create_phone_number(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_phone_number(attrs \\ %{}) do
    %PhoneNumber{}
    |> PhoneNumber.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a phone_number.

  ## Examples

      iex> update_phone_number(phone_number, %{field: new_value})
      {:ok, %PhoneNumber{}}

      iex> update_phone_number(phone_number, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_phone_number(%PhoneNumber{} = phone_number, attrs) do
    phone_number
    |> PhoneNumber.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a phone_number.

  ## Examples

      iex> delete_phone_number(phone_number)
      {:ok, %PhoneNumber{}}

      iex> delete_phone_number(phone_number)
      {:error, %Ecto.Changeset{}}

  """
  def delete_phone_number(%PhoneNumber{} = phone_number) do
    Repo.delete(phone_number)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking phone_number changes.

  ## Examples

      iex> change_phone_number(phone_number)
      %Ecto.Changeset{data: %PhoneNumber{}}

  """
  def change_phone_number(%PhoneNumber{} = phone_number, attrs \\ %{}) do
    PhoneNumber.changeset(phone_number, attrs)
  end
end
