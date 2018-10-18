defmodule MemorexApiWeb.PlaylistController do
  use MemorexApiWeb, :controller

  alias MemorexApi.YouTube

  def show(conn, %{"id" => id}) do
    case YouTube.fetch(id) do
      {:ok, %YouTube.Playlist{} = playlist} ->
        render(conn, "show.json", %{playlist: playlist})
      {:err, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(MemorexApiWeb.ErrorView)
        |> render(:"404")
    end
  end
end
