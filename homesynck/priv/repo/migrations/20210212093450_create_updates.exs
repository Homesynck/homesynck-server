defmodule Homesynck.Repo.Migrations.CreateUpdates do
  use Ecto.Migration

  def change do
    create table(:updates) do
      add :rank, :integer
      add :instructions, :text

      timestamps()
    end

  end
end
