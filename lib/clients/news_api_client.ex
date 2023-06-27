defmodule NewsApi.Clients.NewsApiClient do
  use HTTPoison.Base
  alias NewsApi.Clients.SearchOptions
  require Logger

  @endpoint "https://newsapi.org/v2"

  def search(options \\ %SearchOptions{}) do
    get("/everything?#{qs(options)}")
  end

  def qs(options \\ %SearchOptions{}) do
    options
    |> Map.to_list()
    |> Enum.filter(fn {key, value} -> key != :__struct__ end)
    |> Enum.map(fn item ->
      case item do
        {:tags, value} ->
          q =
            value
            |> Enum.map(fn item ->
              group = [
                "#{item} news",
                "#{item} market",
                "#{item} sector"
              ]  |> Enum.join(" OR ")

              "(#{group})"
            end)
            |> Enum.join(" OR ")
            |> URI.encode_www_form()

          "q=#{q}"

        {_, nil} ->
          nil

        {key, value} ->
          "#{key}=#{value}"
      end
    end)
    |> Enum.filter(fn item -> item != nil end)
    |> Enum.join("&")
  end

  def process_request_url(url) do
    url = @endpoint <> url <> "&apiKey=" <> System.get_env("NEWS_API_KEY")
    Logger.info("NewsApiClient: #{url}")
    url
  end

  def process_response(response) do
    response
    |> Map.get(:body)
    |> Jason.decode!()
  end
end
