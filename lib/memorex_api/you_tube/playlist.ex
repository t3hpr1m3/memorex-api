defmodule MemorexApi.YouTube.Playlist do
  defmodule Thumbnail do
    @derive Jason.Encoder
    defstruct(
      height: nil,
      width: nil,
      url: nil
    )
  end

  defmodule PlaylistItem do
    @derive Jason.Encoder
    defstruct(
      position: nil,
      title: nil,
      thumbnails: %{}
    )
  end

  @derive Jason.Encoder
  defstruct(
    title: nil,
    thumbnails: %{},
    items: nil
  )
end

