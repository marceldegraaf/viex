defmodule ViexTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "lookup" do
    use_cassette "lookup" do
      response = Viex.lookup("NL854265259B01")

      assert response == %Viex.Response{
               address: "PRINS BERNHARDPLEIN 00200\n1097JB AMSTERDAM",
               company: "GITHUB B.V.",
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
  end

  test "valid?" do
    use_cassette "valid" do
      assert Viex.valid?("NL854265259B01") == true
    end
  end

  test "valid? with invalid VAT number" do
    use_cassette "valid_invalid" do
      assert Viex.valid?("NL9999999") == false
    end
  end
end
