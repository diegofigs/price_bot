require Logger

defmodule PriceBot.Core do
  @coingecko_api "https://api.coingecko.com/api/v3"
  def fetch(ticker, opts \\ %{}) do
    optionalParams = %{
      include_market_cap: Map.get(opts, :market_cap, false),
      include_24hr_vol: Map.get(opts, :volume, false),
      include_24hr_change: Map.get(opts, :change, false)
    }
    params = constructParams(ticker, opts) |> Map.merge(optionalParams)

    query_params = URI.encode_query(params)
    price_url = "#{@coingecko_api}/simple/price?#{query_params}"
    headers = [Accept: "Application/json; Charset=utf-8"]

    case HTTPoison.get(price_url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Poison.decode!()
        |> Map.get(ticker)
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
      _ -> "usd"
    end
  end

  def price(ticker) do
    params = constructParams(ticker)
    fetch(ticker, params)
    |> Map.get("usd")
  end

  def market_cap(ticker) do
    params = %{
      market_cap: true
    }
    fetch(ticker, params)
    |> Map.get(optionToField(:market_cap))
  end

  def volume(ticker) do
    params = %{
      volume: true
    }
    fetch(ticker, params)
    |> Map.get(optionToField(:volume))
  end

  def change(ticker) do
    params = %{
      change: true
    }
    fetch(ticker, params)
    |> Map.get(optionToField(:change))
  end

  defp constructParams(ticker, opts \\ %{}) do
    %{
      ids: ticker,
      vs_currencies: Map.get(opts, :currency, "usd")
    }
  end
end
