defmodule MemorexApiWeb.PlaylistView do
  use MemorexApiWeb, :view

  def render("show.json", %{playlist: playlist}) do
    %{playlist: playlist}
  end
end
