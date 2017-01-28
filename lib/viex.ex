defmodule Viex do
  @moduledoc """
  Look up and validate European VAT numbers.
  """

  @url "http://ec.europa.eu/taxation_customs/vies/services/checkVatService"

  @doc """
  Look up a European VAT number. Accepts a binary, returns a `Viex.Response` struct.
  """
  @spec lookup(String.t) :: map | {:error, String.t}
  def lookup(vat_number) do
    vat_number
    |> String.split_at(2)
    |> request
    |> handle_soap_response
    |> Viex.Response.parse
  end

  @doc """
  Check the validity of a European VAT number. Accepts a binary, returns a boolean.
  """
  @spec valid?(String.t) :: boolean
  def valid?(vat_number) do
    vat_number
    |> lookup
    |> is_valid?
  end

  defp is_valid?(%Viex.Response{valid: valid}), do: valid == true
  defp is_valid?({:error, _reason}), do: false

  defp request({country, vat}) do
    HTTPoison.post(@url, body(country, vat), headers(), params: params())
  end

  defp handle_soap_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}
  defp handle_soap_response({:ok, %HTTPoison.Response{status_code: 404}}), do: {:error, :not_found}
  defp handle_soap_response({:ok, %HTTPoison.Response{status_code: 500}}), do: {:error, :internal_server_error}
  defp handle_soap_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, body}

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
