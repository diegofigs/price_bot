defmodule PriceBot.Bot.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      {PriceBot.Bot, System.get_env("BOT_TOKEN")}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
