defmodule NewsService.Repo.Migrations.IncreaseUrlLength do
  use Ecto.Migration

  def change do
    alter table(:feed_items) do
      modify :url, :text
      modify :image, :text
    end
  end
end
