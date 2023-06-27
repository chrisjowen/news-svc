defmodule NewsService.Repo.Migrations.AddAdditionalToFeedItem do
  use Ecto.Migration

  def change do
    alter table(:feed_items) do
      add :author, :string
      add :image, :string
      add :summary, :string
      add :published_at, :utc_datetime
      add :source, :map

    end
  end
end
