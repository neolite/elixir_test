defmodule ApiTest.Router do
  use ApiTest.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiTest do
    pipe_through :api
  end
end
