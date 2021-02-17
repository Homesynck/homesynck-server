defmodule Homesynck.Sync.Controller do
  use Ecto.Schema
  import Ecto.Changeset

  schema "controllers" do
    has_many :updates_emitted, Homesynck.Sync.Update
    belongs_to :user, Homesynck.Auth.User
    field :last_online, :date
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(controller, attrs) do
    controller
    |> cast(attrs, [:name, :last_online])
    |> validate_required([:name, :last_online])
  end
end
