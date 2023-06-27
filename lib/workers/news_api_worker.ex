defmodule NewsService.Workers.NewsApiWorker do
  use Oban.Worker,
    queue: :newsapi,
    max_attempts: 1

  require Logger
  alias NewsService.Schema.FeedItem
  alias NewsService.Repo
  alias NewsApi.Clients.NewsApiClient
  alias NewsApi.Clients.SearchOptions

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    options =
      struct(
        %SearchOptions{},
        args |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
      )

    with {:ok, results} <- NewsApiClient.search(options) do
      persist_results(results, options)
    else
      error ->
        Logger.error(inspect(error))
        :error
    end
  end

  def persist_results(%{"articles" => articles}, options) do
    articles
    |> Enum.each(fn item ->
      FeedItem.changeset(%FeedItem{}, %{
        "media_type" => "html",
        "author" => item["author"],
        "summary" => item["description"],
        "published_at" => item["publishedAt"],
        "source" => %{
          "provider" => "newsapi",
          "inner" => item["source"]
        },
        "title" => item["title"],
        "url" => item["url"],
        "image" => item["urlToImage"],
        "tags" => options.tags,
        "tones" => ["serious", "news"]
      })
      |> Repo.insert()

    end)

    :ok
  end

  def persist_results(error, _) do
    Logger.error(inspect(error))
    :error
  end
end
