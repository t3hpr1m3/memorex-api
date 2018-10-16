defmodule MemorexApi.Playlist do
  alias __MODULE__

  @root_url "https://www.googleapis.com/youtube/v3"

  def fetch(id) do
    with {:ok, playlist} <- fetch_data(id),
         {:ok, items} <- fetch_items(id) do
      {:ok, Map.merge(playlist, %{items: items})}
    else
      {:err, err} ->
        {:err, err}
    end
  end

  defp fetch_data(id) do
    params = %{ id: id, part: "snippet" }

    case make_request("playlists", params) do
      {:ok, %{pageInfo: %{totalResults: 0}}} ->
        {:err, :not_found}
      {:ok, %{items: items}} ->
        {:ok, snippet} = items |> List.first() |> Map.fetch(:snippet)
        thumbnails = extract_thumbnails(snippet[:thumbnails])
        {:ok, %{title: snippet[:title], thumbnails: thumbnails}}
      {:err, err} ->
        {err, :not_found}
    end
  end

  defp fetch_items(id) do
    fetch_items(id, nil, [])
  end

  defp fetch_items(id, next_page_token, items) do
    params = %{
      playlistId: id,
      maxResults: 25,
      part: "snippet,status",
      pageToken: next_page_token
    }

    case make_request("playlistItems", params) do
      {:ok, res} ->
        new_items = Enum.reduce(
          res[:items], items,
          fn (%{status: status, snippet: snippet}, acc) ->
            case status[:privacyStatus] do
              "public" ->
                thumbnails = extract_thumbnails(snippet[:thumbnails])
                [%{title: snippet[:title], thumbnails: thumbnails, position: snippet[:position]} | acc]
              _ ->
                acc
            end
        end)

        case res[:nextPageToken] do
          nil ->
            {:ok, new_items}
          _ ->
            fetch_items(id, res[:nextPageToken], new_items)
        end
    end
  end

  defp extract_thumbnails(data) do
    sizes = ~w(default high maxres medium standard)a
    Enum.reduce(sizes, %{}, fn (size, acc) ->
      if Map.has_key?(data, size) do
        Map.put(acc, size, data[size])
      else
        acc
      end
    end)
  end

  defp make_request(resource, params) do
    {:ok, %{body: raw_body, status_code: code}} = build_url(resource, params)
    |> HTTPoison.get()
    case code do
      404 ->
        {:err, :not_found}
      200 ->
        {:ok, Jason.decode!(raw_body, keys: :atoms)}
    end
  end

  defp build_params(params) do
    Enum.reject(params, fn {_, v} -> is_nil(v) end)
    |> Map.new
    |> Map.merge(%{key: System.get_env("YOUTUBE_API_KEY")})
    |> URI.encode_query()
  end

  defp build_url(resource, params) do
    Enum.join([@root_url, resource], "/")
    |> URI.parse()
    |> Map.put(:query, build_params(params))
    |> URI.to_string()
  end
end
