defmodule NewsService.Repo.Migrations.CreateFeedItems do
  use Ecto.Migration

  def change do
    create table(:feed_items) do
      add :title, :string
      add :url, :string
      add :media_type, :string
      add :tags, {:array, :string}
      add :categories, {:array, :string}
      add :tones, {:array, :string}

      timestamps()
    end

    unique_index(:feed_items, [:url])
  end
end
