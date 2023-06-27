defmodule NewsService.Repo.Migrations.AddExtIdToFeedItem do
  use Ecto.Migration

  def change do
    alter table(:feed_items) do
      add :ext_id, :string
    end
  end
end
