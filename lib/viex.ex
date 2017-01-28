defmodule Viex do
  @moduledoc """
  Documentation for Viex.
  """

  @url "http://ec.europa.eu/taxation_customs/vies/services/checkVatService"

  def verify(country, vat) do
    HTTPoison.post(@url, body(country, vat), headers(), params: params())
    |> handle_soap_response
  end

  defp handle_soap_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}
  defp handle_soap_response({:ok, %HTTPoison.Response{status_code: 404}}), do: {:error, :not_found}
  defp handle_soap_response({:ok, %HTTPoison.Response{status_code: 500}}), do: {:error, :internal_server_error}
  defp handle_soap_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
  end

  defp headers do
    [
      {"SOAPAction", ""},
      {"Content-Type", "text/xml;charset=UTF-8"},
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
