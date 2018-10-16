defmodule MemorexApiWeb.Router do
  use MemorexApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", MemorexApiWeb do
    pipe_through :api

    resources "/playlists", PlaylistController, only: [:show]
  end
end
