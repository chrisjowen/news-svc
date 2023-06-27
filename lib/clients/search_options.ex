defmodule NewsApi.Clients.SearchOptions do
  defstruct tags: [],
            language: "en",
            from: "2023-05-30T00:00:00",
            pageSize: 100
end
