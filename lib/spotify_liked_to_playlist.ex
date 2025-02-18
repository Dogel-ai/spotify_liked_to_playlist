defmodule SpotifyLikedToPlaylist do
  @client_id System.get_env("CLIENT_ID")
  @client_secret System.get_env("CLIENT_SECRET")
  @base_url Req.new(base_url: "https://api.spotify.com/v1")
  @moduledoc """
  Documentation for `SpotifyLikedToPlaylist`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SpotifyLikedToPlaylist.hello()
      :world

  """
  def access_token() do
    # resp = Req.post!(
    #   url: "https://accounts.spotify.com/api/token",
    #   headers: "Content-Type: application/x-www-form-urlencoded",
    #   body: "grant_type=client_credentials&client_id=#{@client_id}&client_secret=#{@client_secret}"
    # )

    req =
      Req.Request.new(
        method: :post,
        url: "https://httpbin.org/post",
        # headers: "Content-Type: application/x-www-form-urlencoded",
        body: "grant_type=client_credentials&client_id=#{@client_id}&client_secret=#{@client_secret}"
      )
      |> Req.Request.append_request_steps(
        put_user_agent: &Req.Steps.put_user_agent/1
      )
      |> Req.Request.append_response_steps(
        decompress_body: &Req.Steps.decompress_body/1,
        decode_body: &Req.Steps.decode_body/1
      )
      |> Req.Request.append_error_steps(
        retry: &Req.Steps.retry/1
      )

    {req, resp} = Req.Request.run_request(req)
    
    req
    # cond do
    #   resp.status == 200 -> resp.body["access_token"]
    #   true -> raise "expected status 200, got #{resp.status}"
    # end
  end
end
