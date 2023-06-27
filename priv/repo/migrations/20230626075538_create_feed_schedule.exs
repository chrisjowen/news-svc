defmodule NewsService.Repo.Migrations.CreateFeedSchedule do
  use Ecto.Migration

  def change do
    create table(:feed_schedule) do
      add :last_ran, :utc_datetime
      add :tags, {:array, :string}
      timestamps()
    end

    unique_index(:feed_schedule, [:tags])

  end
end
