defmodule Homesynck.Sync.Controller do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homesynck.Sync.{Update, UpdateReceived}

  schema "controllers" do
    belongs_to :user, Homesynck.Auth.User
    has_many :updates_emitted, Update, foreign_key: :emitter_id
    many_to_many :updates_received, Update, join_through: UpdateReceived

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
