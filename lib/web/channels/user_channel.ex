defmodule NewsService.UserChannel do
  use Phoenix.Channel
  # alias Phoenix.Socket.Broadcast

  def join("user:" <> _, _params, socket) do
    {:ok, socket
        |> assign(:topics, [])
      }
  end


end
