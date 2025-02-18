defmodule SpotifyLikedToPlaylist do
  def secrets(), do: {System.get_env("CLIENT_ID"), System.get_env("CLIENT_SECRET")}

  def access_token() do
    {client_id, client_secret} = secrets()
    IO.puts(client_id)
    IO.puts(client_secret)
    {:ok, _} = Finch.start_link(name: MyFinch)
    req = Finch.build(
      :post,
      "https://accounts.spotify.com/api/token",
      [{"Content-Type", "application/x-www-form-urlencoded"}],
      "grant_type=client_credentials&client_id=#{client_id}&client_secret=#{client_secret}"
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
