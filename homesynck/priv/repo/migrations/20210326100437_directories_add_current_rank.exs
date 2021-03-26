defmodule Homesynck.Repo.Migrations.DirectoriesAddCurrentRank do
  use Ecto.Migration

  def change do
    alter table(:directories) do
      add :current_rank, :integer, default: 0
    end
  end
end
