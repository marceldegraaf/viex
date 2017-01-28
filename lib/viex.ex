defmodule Viex do
  @moduledoc """
  Documentation for Viex.
  """

  @url "http://ec.europa.eu/taxation_customs/vies/services/checkVatService"

  def verify(country, vat) do
    case HTTPoison.post(@url, body(country, vat), headers(), params: params()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts("Response Body: #{inspect body}")

      {:error, error = %HTTPoison.Error{reason: reason}} -> error
    end
  end

  defp headers do
    [
      {"SOAPAction", ""},
      {"Content-Type", "text/xml;charset=UTF-8"},
      {"Accept-Encoding", "gzip"},
    ]
  end

  defp body(country, vat) do
    ~s(<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ec.europa.eu:taxud:vies:services:checkVat:types">
        <soapenv:Header/>
        <soapenv:Body>
          <urn:checkVat>
            <urn:countryCode>#{country}</urn:countryCode>
            <urn:vatNumber>#{vat}</urn:vatNumber>
          </urn:checkVat>
        </soapenv:Body>
      </soapenv:Envelope>)
  end

  defp params, do: []
end
