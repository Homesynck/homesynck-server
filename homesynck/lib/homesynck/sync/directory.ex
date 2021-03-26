defmodule Homesynck.Sync.Directory do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Homesynck.Auth.User

  schema "directories" do
    belongs_to :user, User, foreign_key: :user_id

    field :description, :string
    field :is_secured, :boolean, default: false
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :thumbnail_url, :string
    field :current_rank, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:name, :description, :thumbnail_url, :is_secured, :password, :user_id])
    |> validate_required([:name, :is_secured, :user_id])
    |> put_pass_hash()
    |> unique_constraint([:name, :user_id])
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password, [{:hash_key, :password_hash}]))
  end

  defp put_pass_hash(changeset), do: changeset

  def with_user_id(query, user_id) do
    query
    |> where([c], c.user_id == ^user_id)
  end

  def with_name(query, name) do
    query
    |> where([c], c.name == ^name)
  end
end
