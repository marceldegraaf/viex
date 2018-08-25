defmodule Viex.ResponseTest do
  use ExUnit.Case, async: true

  @check_vat ~s(<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <checkVatResponse xmlns="urn:ec.europa.eu:taxud:vies:services:checkVat:types">
          <countryCode>NL</countryCode>
          <vatNumber>NL188399277B01</vatNumber>
          <requestDate>2017-01-28+01:00</requestDate>
          <valid>true</valid>
          <name>Acme B.V.</name>
          <address>
            KERKSTRAAT 23\n1234AB FLEVOLAND
          </address>
        </checkVatResponse>
      </soap:Body>
    </soap:Envelope>)

  test "parses a response" do
    response = Viex.Response.parse({:ok, @check_vat})

    assert response == %Viex.Response{
             address: "KERKSTRAAT 23\n1234AB FLEVOLAND",
             company: "Acme B.V.",
             valid: true
           }
  end

  test "returns the error" do
    assert Viex.Response.parse({:error, :the_reason}) == {:error, :the_reason}
  end
end
