defmodule MemorexApi.Repo do
  use Ecto.Repo,
    otp_app: :memorex_api,
    adapter: Ecto.Adapters.Postgres
end
