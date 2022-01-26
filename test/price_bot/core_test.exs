require Logger
defmodule PriceBotCoreTest do
  use ExUnit.Case
  @btc "bitcoin"

  describe "fetch/1" do
    test "returns a map from a coingecko-id" do
      assert PriceBot.Core.fetch("bitcoin") |> is_map()
    end

    test "returns a map from a whitelisted ticker" do
      assert PriceBot.Core.fetch("btc") |> is_map()
    end
  end

  describe "fetch/2" do
    test "returns a map with price, market_cap" do
      assert PriceBot.Core.fetch(@btc, %{market_cap: true}) |> is_map()
    end

    test "returns a map with price, 24h_volume" do
      assert PriceBot.Core.fetch(@btc, %{volume: true}) |> is_map()
    end

    test "returns a map with price, 24h_change" do
      assert PriceBot.Core.fetch(@btc, %{change: true}) |> is_map()
    end

    test "returns a map with price, mc, 24h volume and change" do
      result = PriceBot.Core.fetch(@btc, %{market_cap: true, volume: true, change: true})
      assert result |> is_map()
    end
  end

  test "all/0 returns a binary" do
    result = PriceBot.Core.all()
    assert result |> is_number()
  end

  test "price/1 returns a number" do
    result = PriceBot.Core.price(@btc)
    assert result |> is_number()
  end

  test "market_cap/1 returns a number" do
    result = PriceBot.Core.market_cap(@btc)
    assert result |> is_number()
  end

  test "volume/1 returns a number" do
    result = PriceBot.Core.volume(@btc)
    assert result |> is_number()
  end

  test "change/1 returns a number" do
    result = PriceBot.Core.change(@btc)
    assert result |> is_number()
  end
end
