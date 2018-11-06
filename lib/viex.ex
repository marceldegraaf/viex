defmodule Viex do

  import SweetXml

  alias Viex.Http

  @moduledoc """
  Look up and validate European VAT numbers.
  """

  @url "http://ec.europa.eu/taxation_customs/vies/services/checkVatService"

  @doc """
  Look up a European VAT number. Accepts a binary, returns a `Viex.Response` struct.
  Optionally accepts a `requester_vat` options that needs the VAT number of the entity
  the request is made on behalf of. It returns a `Viex.ApproxResponse` in that case
  """
  @spec lookup(String.t(), [requester_vat: String.t | nil]) :: map | {:error, String.t()}
  def lookup(vat_number, opts \\ []) do
    requester_vat = Keyword.get(opts, :requester_vat)

    response =
      vat_number
      |> String.split_at(2)
      |> request(requester_vat)
      |> handle_soap_response

    case requester_vat do
      nil -> Viex.Response.parse(response)
      _ -> Viex.ApproxResponse.parse(response)
    end
  end

  @doc """
  Check the validity of a European VAT number. Accepts a binary, returns a boolean.
  """
  @spec valid?(String.t(), [requester_vat: String.t | nil]) :: boolean
  def valid?(vat_number, opts \\ []) do
    vat_number
    |> lookup(opts)
    |> is_valid?
  end

  defp is_valid?(%Viex.ApproxResponse{valid: valid}), do: valid == true
  defp is_valid?(%Viex.Response{valid: valid}), do: valid == true
  defp is_valid?({:error, _reason}), do: false

  defp request({country, vat}, nil) do
    Http.post(@url, body(country, vat), headers(), params: params())
  end

  defp request({country, vat}, requester_vat) do
    {requester_country, requester_vat} = String.split_at(requester_vat, 2)

    Http.post(@url, body(country, vat, requester_country, requester_vat), headers(),
      params: params()
    )
  end

  defp handle_soap_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}

  defp handle_soap_response({:ok, %HTTPoison.Response{status_code: 404}}),
    do: {:error, :not_found}

  defp handle_soap_response({:ok, %HTTPoison.Response{status_code: 500}}),
    do: {:error, :internal_server_error}

  defp handle_soap_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    check_for_soap_errors(body)
  end

  defp check_for_soap_errors(body) do
    case get_fault_string(body) do
      nil ->
        {:ok, body}
      fault_string ->
        {:error, {:internal_server_error, fault_string}}
    end
  end

  defp get_fault_string(body) do
    fault_string = body
    |> xpath(~x"//soap:Fault/faultstring/text()")

    case fault_string do
      nil ->
        nil
      charlist ->
        to_string(charlist)
    end
  end

  defp headers do
    [
      {"SOAPAction", ""},
      {"ContentType", "text/xml;charset=UTF8"}
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

  defp body(country, vat, requester_country, requester_vat) do
    ~s(<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ec.europa.eu:taxud:vies:services:checkVat:types">
        <soapenv:Header/>
        <soapenv:Body>
          <urn:checkVatApprox>
            <urn:countryCode>#{country}</urn:countryCode>
            <urn:vatNumber>#{vat}</urn:vatNumber>
            <urn:requesterCountryCode>#{requester_country}</urn:requesterCountryCode>
            <urn:requesterVatNumber>#{requester_vat}</urn:requesterVatNumber>
          </urn:checkVatApprox>
        </soapenv:Body>
      </soapenv:Envelope>)
  end

  defp params, do: []
end
