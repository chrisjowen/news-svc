defmodule Modules do
  alias NewsService.Schema

  @modules [
    {Schema.FeedItem, []},
    {Schema.FeedSchedule, []},

    {Scrivener.Page, []},
  ]

  def modules, do:  @modules
end


Enum.map(Modules.modules, fn {module, strip} ->
  defimpl Jason.Encoder, for: module do
    def encode(schema, options) do
     Util.MapUtil.from_struct(schema, unquote(Modules.modules))
      |>  Jason.Encoder.Map.encode(options)
    end
  end
end)
