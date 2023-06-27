defmodule NewsService.Workers.MediumArticleWorker do
  use Oban.Worker,
    queue: :medium_article,
    max_attempts: 5

  alias NewsService.Schema.FeedItem
  alias NewsService.Repo
  alias NewsApi.Clients.MediumApiClient


  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id, "tags" => tags}}) do
    with {:ok, response} <- MediumApiClient.article(id),
         {:ok, _} <- persist_results(response, tags) do
      :ok
    end
  end

  def persist_results(item, tags) do
    FeedItem.changeset(%FeedItem{}, %{
      "media_type" => "html",
      "author" => item["author"],
      "summary" => item["subtitle"],
      "published_at" => item["published_at"],
      "source" => %{
        "provider" => "medium",
        "id" => item["id"]
      },
      "title" => item["title"],
      "url" => item["url"],
      "image" => item["image_url"],
      "tags" => tags ++ (item["tags"] || []),
      "tones" => ["reading", "learning"],
      "ext_id" => item["id"]
    })
    |> Repo.insert()
  end
end
