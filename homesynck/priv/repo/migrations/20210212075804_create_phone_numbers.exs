defmodule Homesynck.Repo.Migrations.CreatePhoneNumbers do
  use Ecto.Migration

  def change do
    create table(:phone_numbers) do
      add :number_hash, :string
      add :expires_on, :date
      add :register_token, :string

      timestamps()
    end
  end
end
