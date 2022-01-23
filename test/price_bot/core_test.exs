require Logger
defmodule PriceBotCoreTest do
  use ExUnit.Case
  @btc "bitcoin"

  test "fetch/1 requests bitcoin price and returns a number" do
    assert PriceBot.Core.fetch(@btc) > 0
  end

  test "fetch/1 requests bitcoin price with ticker as input" do
    assert PriceBot.Core.fetch("btc") > 0
  end

  test "fetch/2 requests price with market_cap" do
    assert PriceBot.Core.fetch(@btc, %{market_cap: true}) > 0
  end

  test "fetch/2 requests price with 24h_volume" do
    assert PriceBot.Core.fetch(@btc, %{volume: true}) > 0
  end

  test "fetch/2 requests price with 24h_change" do
    assert PriceBot.Core.fetch(@btc, %{change: true}) > 0
  end

  test "fetch/2 requests price, mc, 24h volume and change" do
    result = PriceBot.Core.fetch(@btc, %{market_cap: true, volume: true, change: true})
    assert result > 0
  end

  test "price/1 returns a number" do
    result = PriceBot.Core.price(@btc)
    assert result > 0
  end

  test "market_cap/1 returns a number" do
    result = PriceBot.Core.market_cap(@btc)
    assert result > 0
  end

  test "volume/1 returns a number" do
    result = PriceBot.Core.volume(@btc)
    assert result > 0
  end

  test "change/1 returns a number" do
    result = PriceBot.Core.change(@btc)
    assert result
  end
end
