require Logger

defmodule PriceBot.Core do
  @coingecko_api "https://api.coingecko.com/api/v3"
  @usd "usd"

  @tickers %{
    "btc" => "bitcoin",
    "eth" => "ethereum",
    "bnb" => "binancecoin",
    ada: "cardano",
    sol: "solana",
    luna: "terra-luna",
    dot: "polkadot",
    avax: "avalanche-2",
    matic: "matic-network",
    atom: "cosmos",
    near: "near",
    ftm: "fantom",
    one: "harmony",
    osmo: "osmosis",
    celo: "celo"
  }

  def fetch(ticker, opts \\ %{currency: @usd}) do
    requiredParams = constructParams(ticker, opts)
    optionalParams = %{
      include_market_cap: Map.get(opts, :market_cap, false),
      include_24hr_vol: Map.get(opts, :volume, false),
      include_24hr_change: Map.get(opts, :change, false)
    }
    params = requiredParams |> Map.merge(optionalParams)

    query_params = URI.encode_query(params)
    price_url = "#{@coingecko_api}/simple/price?#{query_params}"
    headers = [Accept: "Application/json; Charset=utf-8"]

    case HTTPoison.get(price_url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Poison.decode!()
        |> Map.get(Map.get(params, :ids))
        |> transform(opts)
      {:error, _} -> %{}
    end
  end

  defp transform(data, opts) do
    keys = Map.keys(opts) |> Enum.map(fn opt -> optionToField(opt) end)

    data
    |> Map.take(keys)
  end

  defp optionToField(opt) do
    case opt do
      :market_cap ->
        "usd_market_cap"
      :volume ->
        "usd_24h_vol"
      :change ->
        "usd_24h_change"
      :price -> @usd
      _ -> @usd
    end
  end

  def price(ticker) do
    fetch(ticker)
    |> Map.get(optionToField(:price))
  end

  def market_cap(ticker) do
    opts = %{market_cap: true}
    fetch(ticker, opts)
    |> Map.get(optionToField(:market_cap))
  end

  def volume(ticker) do
    fetch(ticker, %{volume: true})
    |> Map.get(optionToField(:volume))
  end

  def change(ticker) do
    fetch(ticker, %{change: true})
    |> Map.get(optionToField(:change))
  end

  defp constructParams(ticker, opts) do
    %{
      ids: Map.get(@tickers, ticker, ticker),
      vs_currencies: Map.get(opts, :currency, @usd)
    }
  end
end
