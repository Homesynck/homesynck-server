defmodule Homesynck.Auth.PhoneNumber do
  use Ecto.Schema
  import Ecto.Changeset

  schema "phone_numbers" do
    field :expires_on, :date
    field :number_hash, :string
    field :number, :string, virtual: true
    field :register_token, :string

    timestamps()
  end

  @doc false
  def changeset(phone_number, attrs) do
    phone_number
    |> cast(attrs, [:number, :number_hash, :expires_on, :register_token])
    |> validate_required([:number, :expires_on, :register_token])
  end
end
