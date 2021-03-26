defmodule Homesynck.Sync do
  @moduledoc """
  The Sync context.
  """

  import Ecto.Query, warn: false
  alias Homesynck.Repo

  alias Homesynck.Sync.Update

  @doc """
  Returns the list of updates.

  ## Examples

      iex> list_updates()
      [%Update{}, ...]

  """
  def list_updates do
    Repo.all(Update)
  end

  @doc """
  Gets a single update.

  Raises `Ecto.NoResultsError` if the Update does not exist.

  ## Examples

      iex> get_update!(123)
      %Update{}

      iex> get_update!(456)
      ** (Ecto.NoResultsError)

  """
  def get_update!(id), do: Repo.get!(Update, id)

  @doc """
  Creates a update.

  ## Examples

      iex> create_update(%{field: value})
      {:ok, %Update{}}

      iex> create_update(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_update(attrs \\ %{}) do
    %Update{}
    |> Update.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a update.

  ## Examples

      iex> update_update(update, %{field: new_value})
      {:ok, %Update{}}

      iex> update_update(update, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_update(%Update{} = update, attrs) do
    update
    |> Update.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a update.

  ## Examples

      iex> delete_update(update)
      {:ok, %Update{}}

      iex> delete_update(update)
      {:error, %Ecto.Changeset{}}

  """
  def delete_update(%Update{} = update) do
    Repo.delete(update)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking update changes.

  ## Examples

      iex> change_update(update)
      %Ecto.Changeset{data: %Update{}}

  """
  def change_update(%Update{} = update, attrs \\ %{}) do
    Update.changeset(update, attrs)
  end

  alias Homesynck.Sync.Directory

  @doc """
  Returns the list of directories.

  ## Examples

      iex> list_directories()
      [%Directory{}, ...]

  """
  def list_directories do
    Repo.all(Directory)
  end

  def get_user_directory_by_name(user_id, name) do
    directories_with_name =
      Directory
      |> Directory.with_user_id(user_id)
      |> Directory.with_name(name)
      |> Repo.all()

    case directories_with_name do
      [first_dir | _] -> {:ok, first_dir}
      _ -> {:error, :not_found}
    end
  end

  def directory_id_owned_by_user_id?(user_id, dir_id) do
    try do
      dir = get_directory!(dir_id)
      dir.user_id == user_id
    rescue
      _ -> false
    end
  end

  @doc """
  Gets a single directory.

  Raises `Ecto.NoResultsError` if the Directory does not exist.

  ## Examples

      iex> get_directory!(123)
      %Directory{}

      iex> get_directory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_directory!(id), do: Repo.get!(Directory, id)

  def get_directory(id) do
    dir = Repo.get(Directory, id)

    case dir do
      %Directory{} -> {:ok, dir}
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Creates a directory.

  ## Examples

      iex> create_directory(%{field: value})
      {:ok, %Directory{}}

      iex> create_directory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_directory_for(
        user_id,
        %{
          "name" => _dir_name,
          "is_secured" => _dir_is_secured
        } = attrs
      ) do
    case insert_directory(Map.put(attrs, "user_id", user_id)) do
      {:ok, directory} ->
        {:ok, directory.id}

      error ->
        # TODO
        error
        |> IO.inspect()
    end
  end

  defp insert_directory(attrs) do
    %Directory{}
    |> Directory.changeset(attrs)
    |> Repo.insert()
  end

  def open_directory(directory_id, user_id, password \\ "") do
    with true <- directory_id_owned_by_user_id?(user_id, directory_id),
         {:ok, %Directory{} = directory} <- get_directory(directory_id),
         {:ok, directory} <- authenticate_directory(directory, password) do
      {:ok, directory}
    else
      _ -> {:error, :access_denied}
    end
  end

  def authenticate_directory(
        %Directory{
          is_secured: is_secured
        } = dir,
        password
      ) do
    if is_secured do
      Argon2.check_pass(dir, password, [{:hash_key, :password_hash}])
    else
      {:ok, dir}
    end
  end

  @doc """
  Updates a directory.

  ## Examples

      iex> update_directory(directory, %{field: new_value})
      {:ok, %Directory{}}

      iex> update_directory(directory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_directory(%Directory{} = directory, attrs) do
    directory
    |> Directory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a directory.

  ## Examples

      iex> delete_directory(directory)
      {:ok, %Directory{}}

      iex> delete_directory(directory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_directory(%Directory{} = directory) do
    Repo.delete(directory)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking directory changes.

  ## Examples

      iex> change_directory(directory)
      %Ecto.Changeset{data: %Directory{}}

  """
  def change_directory(%Directory{} = directory, attrs \\ %{}) do
    Directory.changeset(directory, attrs)
  end
end
