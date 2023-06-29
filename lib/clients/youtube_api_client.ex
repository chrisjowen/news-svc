defmodule NewsApi.Clients.YouTubeApiClient do
  use HTTPoison.Base
  alias NewsApi.Clients.SearchOptions
  @endpoint "https://www.googleapis.com/youtube/v3"


  def search(options) do
   get("/search?#{qs(options)}")
  end

  def qs(options \\ %SearchOptions{}) do
    options
    |> Map.to_list()
    |> Enum.filter(fn {key, value} -> key != :__struct__ end)
    |> Enum.map(fn item ->
      case item do
        {:tags, value} ->

          q = value
          |> Enum.map(fn item -> "\"#{item}\"" end)
          |> Enum.join(" AND ")
          |> URI.encode_www_form()

          "q=#{q}"
        {:from, value} -> "publishedAfter=#{URI.encode_www_form(value)}"
        {key, nil} -> nil
        {key, value} -> "#{key}=#{value}"
      end
    end)
    |> Enum.filter(fn item -> item != nil end)
    |> Enum.join("&")
  end

  def process_request_url(url) do
    @endpoint <> url <> "&part=snippet&key=" <> System.get_env("YOUTUBE_API_KEY") |> IO.inspect
  end

  def process_response(response) do
   response
    |> Map.get(:body)
    |> Jason.decode!()
  end
end
