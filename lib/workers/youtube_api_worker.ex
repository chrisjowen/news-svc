defmodule NewsService.Workers.YouTubeApiWorker do
  use Oban.Worker,
    queue: :youtube,
    max_attempts: 3

  alias NewsService.Schema.FeedItem
  alias NewsService.Repo
  alias NewsApi.Clients.YouTubeApiClient
  alias NewsApi.Clients.SearchOptions
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    options =
      struct(
        %SearchOptions{},
        args |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
      )

    with {:ok, results} <- YouTubeApiClient.search(options) do
      persist_results(results, options)
    else
      error ->
        Logger.error(inspect(error))
        :error
    end
  end

  def persist_results(%{"items" => items}, options) do
    items
    |> Enum.filter(fn item -> item["id"]["kind"] == "youtube#video" end)
    |> Enum.each(fn item ->
      snippet = item["snippet"]

      FeedItem.changeset(%FeedItem{}, %{
        "media_type" => "youtube",
        "author" => item["author"],
        "summary" => snippet["description"],
        "published_at" => snippet["publishedAt"],
        "source" => %{
          "provider" => "youtube",
          "channelId" => snippet["channelId"],
          "id" => item["id"]["videoId"]
        },
        "title" => snippet["title"],
        "url" => "https://www.youtube.com/watch?v=" <> item["id"]["videoId"],
        "image" => snippet["thumbnails"]["medium"]["url"],
        "tags" => options.tags,
        "tones" => ["entertainment", "video"],
        "ext_id" => item["id"]["videoId"]
      })
      |> Repo.insert!()
      |> IO.inspect()
    end)

    :ok
  end

  def persist_result(error, options) do
    Logger.error(inspect(error))
    :error
  end
end
