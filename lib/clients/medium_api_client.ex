defmodule NewsApi.Clients.MediumApiClient do
  use HTTPoison.Base

  @endpoint "https://medium2.p.rapidapi.com"

  def search(q) do
    get("/search/articles?query=#{q}", [],
      timeout: 50_000,
      recv_timeout: 50_000
    )
  end

  def article(id) do
    get("/article/#{id}", [],
      timeout: 50_000,
      recv_timeout: 50_000
    )
  end

  def process_request_headers(headers) do
    headers ++
      [
        {"X-RapidAPI-Key", System.get_env("RAPID_API_KEY")},
        {"X-RapidAPI-Host", "medium2.p.rapidapi.com"}
      ]
  end

  def process_request_url(url) do
    @endpoint <> url
  end

  def process_response(response) do
    response
    |> Map.get(:body)
    |> Jason.decode!()
  end
end
