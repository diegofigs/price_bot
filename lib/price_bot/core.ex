require Logger

defmodule PriceBot.Core do
  def fetch(ticker) do
    params = %{ids: ticker, vs_currencies: "usd"}
    query_params = URI.encode_query(params)

    price_url = "https://api.coingecko.com/api/v3/simple/price?#{query_params}"
    headers = [Accept: "Application/json; Charset=utf-8"]

    case HTTPoison.get(price_url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Poison.decode!()
        |> Map.get(ticker)
        |> Map.get("usd")
    end
  end
end
