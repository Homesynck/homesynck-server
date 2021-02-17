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

  alias Homesynck.Sync.UpdateReceived

  @doc """
  Returns the list of updates_received.

  ## Examples

      iex> list_updates_received()
      [%UpdateReceived{}, ...]

  """
  def list_updates_received do
    Repo.all(UpdateReceived)
  end

  @doc """
  Gets a single update_received.

  Raises `Ecto.NoResultsError` if the Update received does not exist.

  ## Examples

      iex> get_update_received!(123)
      %UpdateReceived{}

      iex> get_update_received!(456)
      ** (Ecto.NoResultsError)

  """
  def get_update_received!(id), do: Repo.get!(UpdateReceived, id)

  @doc """
  Creates a update_received.

  ## Examples

      iex> create_update_received(%{field: value})
      {:ok, %UpdateReceived{}}

      iex> create_update_received(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_update_received(attrs \\ %{}) do
    %UpdateReceived{}
    |> UpdateReceived.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a update_received.

  ## Examples

      iex> update_update_received(update_received, %{field: new_value})
      {:ok, %UpdateReceived{}}

      iex> update_update_received(update_received, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_update_received(%UpdateReceived{} = update_received, attrs) do
    update_received
    |> UpdateReceived.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a update_received.

  ## Examples

      iex> delete_update_received(update_received)
      {:ok, %UpdateReceived{}}

      iex> delete_update_received(update_received)
      {:error, %Ecto.Changeset{}}

  """
  def delete_update_received(%UpdateReceived{} = update_received) do
    Repo.delete(update_received)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking update_received changes.

  ## Examples

      iex> change_update_received(update_received)
      %Ecto.Changeset{data: %UpdateReceived{}}

  """
  def change_update_received(%UpdateReceived{} = update_received, attrs \\ %{}) do
    UpdateReceived.changeset(update_received, attrs)
  end

  alias Homesynck.Sync.Controller

  @doc """
  Returns the list of controllers.

  ## Examples

      iex> list_controllers()
      [%Controller{}, ...]

  """
  def list_controllers do
    Repo.all(Controller)
  end

  @doc """
  Gets a single controller.

  Raises `Ecto.NoResultsError` if the Controller does not exist.

  ## Examples

      iex> get_controller!(123)
      %Controller{}

      iex> get_controller!(456)
      ** (Ecto.NoResultsError)

  """
  def get_controller!(id), do: Repo.get!(Controller, id)

  @doc """
  Creates a controller.

  ## Examples

      iex> create_controller(%{field: value})
      {:ok, %Controller{}}

      iex> create_controller(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_controller(attrs \\ %{}) do
    %Controller{}
    |> Controller.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a controller.

  ## Examples

      iex> update_controller(controller, %{field: new_value})
      {:ok, %Controller{}}

      iex> update_controller(controller, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_controller(%Controller{} = controller, attrs) do
    controller
    |> Controller.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a controller.

  ## Examples

      iex> delete_controller(controller)
      {:ok, %Controller{}}

      iex> delete_controller(controller)
      {:error, %Ecto.Changeset{}}

  """
  def delete_controller(%Controller{} = controller) do
    Repo.delete(controller)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking controller changes.

  ## Examples

      iex> change_controller(controller)
      %Ecto.Changeset{data: %Controller{}}

  """
  def change_controller(%Controller{} = controller, attrs \\ %{}) do
    Controller.changeset(controller, attrs)
  end
end
