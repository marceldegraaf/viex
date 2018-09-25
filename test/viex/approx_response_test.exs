defmodule Viex.ApproxResponseTest do
  use ExUnit.Case, async: false

  @check_vat_approx ~s(<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">
    <soap:Body>
      <checkVatApproxResponse xmlns=\"urn:ec.europa.eu:taxud:vies:services:checkVat:types\">
          <countryCode>NL</countryCode>
          <vatNumber>854265259B01</vatNumber>
          <requestDate>2018-08-25+02:00</requestDate>
          <valid>true</valid>
          <traderName>GITHUB B.V.</traderName>
          <traderCompanyType>---</traderCompanyType>
          <traderAddress>\nVIJZELSTRAAT 00068\n1017HL AMSTERDAM\n</traderAddress>
          <requestIdentifier>WAPIAAAAWVymNggi</requestIdentifier>
      </checkVatApproxResponse>
    </soap:Body>
  </soap:Envelope>)

  setup context do
    case context[:debug] do
      true ->
        Application.put_env(:viex, :debug_enabled, true)
        on_exit fn -> Application.put_env(:viex, :debug_enabled, false) end
      _ ->
        :ok
    end
  end

  test "parses a response" do
    response = Viex.ApproxResponse.parse({:ok, @check_vat_approx})

    assert response == %Viex.ApproxResponse{
             trader_city: nil,
             trader_postcode: nil,
             trader_street: nil,
             valid: true,
             request_identifier: "WAPIAAAAWVymNggi",
             trader_address: "VIJZELSTRAAT 00068\n1017HL AMSTERDAM",
             trader_company_type: "---",
             trader_name: "GITHUB B.V.",
             response_body: nil
           }
  end

  test "returns the error" do
    assert Viex.ApproxResponse.parse({:error, :the_reason}) == {:error, :the_reason}
  end

  @tag debug: true
  test "parses a response with request body" do
    response = Viex.ApproxResponse.parse({:ok, @check_vat_approx})

    assert response == %Viex.ApproxResponse{
             trader_city: nil,
             trader_postcode: nil,
             trader_street: nil,
             valid: true,
             request_identifier: "WAPIAAAAWVymNggi",
             trader_address: "VIJZELSTRAAT 00068\n1017HL AMSTERDAM",
             trader_company_type: "---",
             trader_name: "GITHUB B.V.",
             response_body: @check_vat_approx}
  end
end
