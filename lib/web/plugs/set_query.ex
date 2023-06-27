defmodule NewsService.SetQuery do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    cond do
      match?(%{"solution_id" => _id}, conn.params) ->
        assign(conn, :q, "solution_id=#{conn.params["solution_id"]}")

      match?(%{"problem_id" => _id}, conn.params) ->
        assign(conn, :q, "problem_id=#{conn.params["problem_id"]}")

      true ->
        conn
    end
  end
end
