defmodule Homesynck.Sync.Update do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Homesynck.Sync.Directory

  schema "updates" do
    belongs_to :directory, Directory, foreign_key: :directory_id

    field :instructions, :string
    field :rank, :integer

    timestamps()
  end

  @doc false
  def changeset(update, attrs) do
    update
    |> cast(attrs, [:rank, :instructions, :directory_id])
    |> validate_required([:rank, :instructions, :directory_id])
    |> unique_constraint([:rank, :directory_id])
  end

  def with_rank(query, rank) do
    query
    |> where([c], c.rank == ^rank)
  end

  def with_directory_id(query, dir_id) do
    query
    |> where([c], c.directory_id == ^dir_id)
  end
end
