defmodule PriceBot.Bot.Commands do
  use Alchemy.Cogs

  Cogs.def price do
    Cogs.say("Please give me a coingecko token-id")
  end

  Cogs.def price(word) do
    response = PriceBot.Core.price(word) |> Money.parse!() |> Money.to_string()
    Cogs.say(response)
  end

  Cogs.def mc(word) do
    response = PriceBot.Core.market_cap(word) |> Money.parse!() |> Money.to_string()
    Cogs.say(response)
  end

  Cogs.def volume(word) do
    response = PriceBot.Core.volume(word) |> Money.parse!() |> Money.to_string()
    Cogs.say(response)
  end
end