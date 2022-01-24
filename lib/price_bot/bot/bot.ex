defmodule PriceBot.Bot do
  use GenServer
  alias Alchemy.Client

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_) do
    run = Client.start(Application.fetch_env!(:price_bot, :token))
    use PriceBot.Bot.Commands
    run
  end
end
