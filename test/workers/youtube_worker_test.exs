defmodule Workers.YoutubeWorkerTest do
  use NewsService.DataCase
  use Oban.Testing, repo: NewsService.Repo
  alias NewsService.Workers.YouTubeApiWorker
  alias NewsApi.Clients.YouTubeApiClient
  import Mock

  @resourcePath File.cwd!() <> "/test/resource"

  test "Will Correctly Save Response" do
    response = File.read!("#{@resourcePath}/youtube.success.json") |> Jason.decode!()

    with_mock YouTubeApiClient, [search: fn options -> {:ok, response} end] do
      YouTubeApiWorker.perform(%Oban.Job{args: %{"tags" => ["foo"]}})
    end
  end
end

# defmodule MyTest do
#   use ExUnit.Case, async: false
#   alias NewsApi.Clients.YouTubeApiClient
#   import Mock
#   @resourcePath File.cwd!() <> "/test/resource"

#   test "test_name" do
#     response = File.read!("#{@resourcePath}/youtube.success.json") |> Jason.decode!()

#     with_mock YouTubeApiClient, [search: fn(_url) -> {:ok, response} end] do
#       YouTubeApiWorker.perform(%Oban.Job{args: %{"tags" => ["foo"]}})
#     end
#   end
# end
