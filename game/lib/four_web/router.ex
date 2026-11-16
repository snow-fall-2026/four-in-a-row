defmodule FourWeb.Router do
  use FourWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FourWeb do
    pipe_through :api
  end
end
