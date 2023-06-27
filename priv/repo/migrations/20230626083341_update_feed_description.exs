defmodule NewsService.Repo.Migrations.UpdateFeedDescription do
  use Ecto.Migration

  def change do
    alter table(:feed_items) do
      modify :summary, :text
    end
  end
end
