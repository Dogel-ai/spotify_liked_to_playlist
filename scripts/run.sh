#!/bin/bash

source .env

export CLIENT_ID=$CLIENT_ID
export CLIENT_SECRET=$CLIENT_SECRET
MIX_ENV=prod mix release
./_build/prod/rel/spotify_liked_to_playlist/bin/spotify_liked_to_playlist start_iex
