defmodule PriceBot.Bot do
  use GenServer, restart: :transient
  alias Alchemy.Client

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def price do
      Cogs.say("Please give me a coingecko token-id")
    end

    Cogs.def price(word) do
      Cogs.say(PriceBot.Core.fetch(word))
    end
  end

  @impl true
  def init(token) do
    run = Client.start(token)
    use Commands
    run
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end
end
