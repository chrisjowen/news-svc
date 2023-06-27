# alias NewsService.Workers.ScheduledWorker
alias Phx.New
alias NewsService.Workers



# NewsService.Workers.YouTubeApiWorker.new(%{
#   tags: ["bitcoin", "cryptocurrency"]
# })
# |> Oban.insert!()


# import Ecto.Query
# alias NewsService.Schema.FeedItem
# alias NewsService.Repo


# |> IO.inspect()

args = Jason.encode!(%{
  tags: ["Augmented reality (AR)"]
}) |> Jason.decode!()

# Workers.MediumSearchWorker.perform(%Oban.Job{
#   args: args
# })


# Workers.NewsApiWorker.new(%{
#   tags: ["Augmented Reality (AR)", "Virtual Reality (VR)"]
# })
# |> Oban.insert!()

# Workers.NewsApiWorker.new(%{
#   tags: ["Augmented Reality (AR)", "Virtual Reality (VR)"]
# })
# |> Oban.insert!()


Workers.NewsApiWorker.perform(%Oban.Job{args: args})

# Workers.ScheduledWorker.new(%{
#   last_ran: DateTime.utc_now(),
# }) |> Oban.insert!
