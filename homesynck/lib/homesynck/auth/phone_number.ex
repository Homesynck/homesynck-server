defmodule Homesynck.Auth.PhoneNumber do
  use Ecto.Schema
  import Ecto.Changeset

  schema "phone_numbers" do
    field :expires_on, :date
    field :number, :string
    field :register_token, :string
    field :verification_code, :string

    timestamps()
  end

  @doc false
  def changeset(phone_number, attrs) do
    phone_number
    |> cast(attrs, [:number, :expires_on, :verification_code, :register_token])
    |> validate_required([:number, :expires_on, :verification_code, :register_token])
  end
end
