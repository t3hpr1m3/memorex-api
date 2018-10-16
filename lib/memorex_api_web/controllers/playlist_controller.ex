defmodule MemorexApiWeb.PlaylistController do
  use MemorexApiWeb, :controller

  def show(conn, %{"id" => id}) do
    case MemorexApi.Playlist.fetch(id) do
      {:ok, %{} = playlist} ->
        render(conn, "show.json", %{playlist: playlist})
      {:err, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(MemorexApiWeb.ErrorView)
        |> render(:"404")
    end
  end
end
