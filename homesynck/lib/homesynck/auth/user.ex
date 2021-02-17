defmodule Homesynck.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_many :controllers, Homesynck.Sync.Controller
    field :email, :string
    field :name, :string
    field :password_hashed, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :password])
  end
end
