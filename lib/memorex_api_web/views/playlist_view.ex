defmodule MemorexApiWeb.PlaylistView do
  use MemorexApiWeb, :view
  alias MemorexApi.YouTube

  def render("show.json", %{playlist: %YouTube.Playlist{} = playlist}) do
    %{playlist: playlist}
  end
end
