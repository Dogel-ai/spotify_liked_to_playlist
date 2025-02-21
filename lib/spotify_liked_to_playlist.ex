defmodule SpotifyLikedToPlaylist do
  @redirect_uri "http://127.0.0.1:3000/callback"
  def secrets(), do: {System.get_env("CLIENT_ID"), System.get_env("CLIENT_SECRET")}

  def run() do
    {:ok, _} = Finch.start_link(name: MyFinch)
  end

  def access_token(user_code) do
    {client_id, client_secret} = secrets()

    req = Finch.build(
      :post,
      "https://accounts.spotify.com/api/token",
      [{"Content-Type", "application/x-www-form-urlencoded"}, {"Authorization", "Basic #{Base.encode64("#{client_id}:#{client_secret}")}"}],
      "grant_type=authorization_code&code=#{user_code}&redirect_uri=#{@redirect_uri}"
    )
    {:ok, resp} = Finch.request(req, MyFinch)

    cond do
      resp.status == 200 -> resp.body
        |> Jason.decode!()
        |> Map.get("access_token")
      true -> raise "expected code 200, got #{resp.status}"
    end
  end
end
