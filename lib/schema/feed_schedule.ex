defmodule NewsService.Schema.FeedSchedule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feed_schedule" do
    field :last_ran, :utc_datetime, default: ~U[2022-01-12 00:00:00.00Z] |> DateTime.truncate( :second)
    field :tags, {:array, :string}
    timestamps()
  end

  @doc false
  def changeset(feed_schedule, attrs) do
    IO.inspect(attrs)
    feed_schedule
    |> cast(attrs, [:last_ran, :tags])
    |> validate_required([:last_ran, :tags])
    |> IO.inspect
  end
end
