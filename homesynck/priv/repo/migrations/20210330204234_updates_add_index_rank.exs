defmodule Homesynck.Repo.Migrations.UpdatesAddIndexRank do
  use Ecto.Migration

  def change do
    create index(:updates, [:directory_id, :rank])
  end
end
