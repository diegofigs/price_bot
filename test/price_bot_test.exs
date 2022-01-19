defmodule PriceBotTest do
  use ExUnit.Case

  test "fetch requests price and returns an integer" do
    assert PriceBot.Core.fetch("bitcoin") > 0
  end
end
