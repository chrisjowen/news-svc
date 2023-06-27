defmodule NewsService.Workers.MediumSearchWorker do
  use Oban.Worker,
    queue: :medium,
    max_attempts: 5

  import Ecto.Query
  alias NewsService.Schema.FeedItem
  alias NewsService.Repo
  alias NewsApi.Clients.MediumApiClient
  alias NewsService.Workers.MediumArticleWorker

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"tags" => tags}}) do
    q = Enum.join(tags, ",") |> IO.inspect()

    with {:ok, response} <- MediumApiClient.search(q) do
      process_results(response, tags)
    else
      error ->
        :error
        IO.inspect(error)
    end
  end

  def process_results(%{"error" => error}, tags) do
    IO.inspect(error)
    :error
  end
  def process_results(%{"articles" => articles}, tags) do
    id = (from a in FeedItem, where: a.source["provider"] == "medium")
    |> Repo.all()
    |> Enum.map(&(&1.ext_id))

    articles
    |> Enum.filter(fn article -> !Enum.member?(id, article) end)
    |> Enum.take(10)
    |> Enum.each(fn id ->
      MediumArticleWorker.new(%{
        id: id,
        tags: tags
      })
      |> Oban.insert()
    end)

    :ok
  end

  def process_results(error, tags) do
    IO.inspect(error)
    :error
  end
end
