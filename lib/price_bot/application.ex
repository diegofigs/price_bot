defmodule PriceBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PriceBot.Repo,
      # Start the Telemetry supervisor
      PriceBotWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PriceBot.PubSub},
      # Start the Endpoint (http/https)
      PriceBotWeb.Endpoint,
      # Start the Discord bot supervisor
      {PriceBot.Bot.Supervisor, Application.get_env(:price_bot, :token)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PriceBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PriceBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end