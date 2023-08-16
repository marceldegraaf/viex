defmodule ViexTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "lookup" do
    use_cassette "lookup" do
      response = Viex.lookup("NL854265259B01")

      assert response == %Viex.Response{
               address: "VIJZELSTRAAT 00068\n1017HL AMSTERDAM",
               company: "GITHUB B.V.",
               valid: true
             }
    end

    use_cassette "lookup with requester vat" do
      response = Viex.lookup("NL854265259B01", requester_vat: "IE6388047V")

      assert response == %Viex.ApproxResponse{
               request_identifier: "WAPIAAAAYnkVx97D",
               trader_address: "VIJZELSTRAAT 00068\n1017HL AMSTERDAM",
               trader_city: nil,
               trader_company_type: "---",
               trader_name: "GITHUB B.V.",
               trader_postcode: nil,
               trader_street: nil,
               valid: true
             }
    end
  end

  test "lookup with invalid VAT number" do
    use_cassette "lookup_invalid" do
      response = Viex.lookup("NL9999999")

      assert response == %Viex.Response{
               address: "---",
               company: "---",
               valid: false
             }
    end

    use_cassette "lookup_invalid with requester vat" do
      response = Viex.lookup("NL9999999", requester_vat: "IE6388047V")

      assert response == %Viex.ApproxResponse{
               trader_city: nil,
               trader_company_type: "---",
               trader_postcode: nil,
               trader_street: nil,
               request_identifier: nil,
               trader_address: "---",
               trader_name: "---",
               valid: false
             }
    end
  end

  test "valid?" do
    use_cassette "valid" do
      assert Viex.valid?("NL854265259B01") == true
    end

    use_cassette "valid with requester vat" do
      assert Viex.valid?("NL854265259B01", requester_vat: "IE6388047V") == true
    end
  end

  test "valid? with invalid VAT number" do
    use_cassette "valid_invalid" do
      assert Viex.valid?("NL9999999") == false
    end

    use_cassette "valid_invalid with requester vat" do
      assert Viex.valid?("NL9999999", requester_vat: "IE6388047V") == false
    end
  end
end
