require Logger

defmodule PriceBot.Core do
  @coingecko_api "https://api.coingecko.com/api/v3"
  @usd "usd"

  @tickers %{
    "btc" => "bitcoin",
    "eth" => "ethereum",
    "bnb" => "binancecoin",
    "ada" => "cardano",
    "sol" => "solana",
    "luna" => "terra-luna",
    "dot" => "polkadot",
    "avax" => "avalanche-2",
    "matic" => "matic-network",
    "atom" => "cosmos",
    "ftm" => "fantom",
    "one" => "harmony",
    "osmo" => "osmosis",
    "magic" => "cosmic-universe-magic-token",
    "cosmic" => "cosmic-coin",
    "jewel" => "defi-kingdoms",
    "boo" => "spookyswap",
    "spirit" => "spiritswap",
    "lqdr" => "liquiddriver",
    "wmemo" => "wrapped-memory",
    "spell" => "spell-token",
    "crv" => "curve-dao-token",
    "baby" => "babyswap",
    "aurora" => "aurora-near",
    "brl" => "borealis",
    "tri" => "trisolaris",
    "pad" => "nearpad"
  }

  @default %{
    currency: @usd,
    market_cap: false,
    volume: false,
    change: false,
  }
  def fetch(ticker, opts \\ @default) do
    required = constructParams(ticker, opts)
    optional = %{
      include_market_cap: Map.get(opts, :market_cap, @default[:market_cap]),
      include_24hr_vol: Map.get(opts, :volume, @default[:volume]),
      include_24hr_change: Map.get(opts, :change, @default[:change])
    }
    params = Map.merge(required, optional)

    query_params = URI.encode_query(params)
    price_url = "#{@coingecko_api}/simple/price?#{query_params}"
    headers = [Accept: "Application/json; Charset=utf-8"]

    case HTTPoison.get(price_url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Poison.decode!()
        |> Map.get(params[:ids])
        |> transform(opts)
      {:error, _} -> %{}
    end
  end

  def price(ticker) do
    fetch(ticker)
    |> Map.get(optionToField(:currency))
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

  ## Private

  defp constructParams(ticker, opts) do
    %{
      ids: Map.get(@tickers, ticker, ticker),
      vs_currencies: Map.get(opts, :currency, @default[:currency])
    }
  end

  defp transform(data, opts) do
    all_options = Map.merge(@default, opts)
    keys = all_options
    |> Enum.to_list()
    |> Enum.filter(fn ({_, value}) -> value == true or is_bitstring(value) end)
    |> Enum.map(fn ({key, _}) -> optionToField(key, all_options[:currency]) end)

    data
    |> Map.take(keys)
  end

  defp optionToField(opt, currency \\ @usd) do
    case opt do
      :currency -> currency
      :market_cap ->
        "#{currency}_market_cap"
      :volume ->
        "#{currency}_24h_vol"
      :change ->
        "#{currency}_24h_change"
    end
  end
end
