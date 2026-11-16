defmodule Four.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FourWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:four, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Four.PubSub},
      # Start a worker by calling: Four.Worker.start_link(arg)
      # {Four.Worker, arg},
      # Start to serve requests, typically the last entry
      FourWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Four.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FourWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
