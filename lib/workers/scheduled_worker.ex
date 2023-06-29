defmodule NewsService.Workers.ScheduledWorker do
  alias ProblemService.Schema
  require Logger

  use Oban.Worker,
    queue: :scheduler,
    max_attempts: 1

  import Ecto.Query

  alias NewsService.Schema.FeedSchedule
  alias NewsService.Repo

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    schedules = Repo.all(FeedSchedule)
    Logger.info("Scheduling #{length(schedules)} feeds")

    schedules
    |> Enum.take(1)
    |> Enum.each(fn fs -> schedule_worker(fs) end)
  end

  def get_schedules(args) do
    last_ran =
      case args["last_ran"] do
        nil ->
          DateTime.utc_now()

        date ->
          {:ok, parsed, _} = date |> DateTime.from_iso8601()
          parsed
      end

    runtime = last_ran |> DateTime.add(4, :hour)

    Logger.info("Scheduling feeds that last ran before #{runtime}")

    q = from(fs in FeedSchedule, where: fs.last_ran < ^runtime, limit: 5)

    schedules = Repo.all(q)
  end

  def schedule_worker(schedule) do
    args = %{tags: schedule.tags, from: schedule.last_ran}

    [
      # {NewsService.Workers.NewsApiWorker, args},
      {NewsService.Workers.YouTubeApiWorker, args},
      {NewsService.Workers.MediumSearchWorker, args}
    ]
    |> Enum.each(fn {module, params} ->
      Logger.info("Scheduling worker #{inspect(module)} with args #{inspect(params)}")
      apply(module, :new, [params]) |> Oban.insert!()
    end)

    FeedSchedule.changeset(schedule, %{last_ran: DateTime.utc_now() |> DateTime.truncate(:second)})
    |> Repo.update!()
  end
end
