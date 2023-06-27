defmodule NewsService.Schema.FeedItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feed_items" do
    field :categories, {:array, :string}
    field :media_type, :string
    field :tags, {:array, :string}
    field :title, :string
    field :tones, {:array, :string}
    field :url, :string
    field :author, :string
    field :image, :string
    field :ext_id, :string
    field :summary, :string
    field :published_at, :utc_datetime
    field :source, :map
    timestamps()
  end

  @doc false
  def changeset(feed_item, attrs) do
    feed_item
    |> cast(attrs, [:title, :url, :media_type, :tags, :categories, :tones, :published_at, :source, :author, :image, :ext_id, :summary])
    |> validate_required([:title, :url, :media_type, :tags, :source, :published_at])
  end
end
