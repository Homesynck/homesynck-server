defmodule Homesynck.Sync.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "directories" do
    field :description, :string
    field :is_secured, :boolean, default: false
    field :name, :string
    field :password_hash, :string
    field :thumbnail_url, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:name, :description, :thumbnail_url, :is_secured, :password_hash])
    |> validate_required([:name, :description, :thumbnail_url, :is_secured, :password_hash])
  end
end
