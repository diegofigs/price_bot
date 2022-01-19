defmodule PriceBot.Bot.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(token) do
    children = [
      {PriceBot.Bot, token}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
