defmodule NewsService.FeedScheduleController do
  use NewsService.BaseController, schema: NewsService.Schema.FeedSchedule


  def run_schedules(conn, _) do
     NewsService.Workers.ScheduledWorker.new(%{}) |> Oban.insert!
     json(conn, :ok)
  end

end
