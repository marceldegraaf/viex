defmodule SoapErrorTest do
  use ExUnit.Case, async: false
  import Mox

  setup_all do
    Mox.defmock(Viex.Http, for: Viex.Http.Behaviour)
    :ok
  end

  setup :verify_on_exit!

  describe "when a member state is unavailable," do
    setup :ms_unavailable

    test "return internal_server_error with provided reason" do
      response = Viex.lookup("SE12345689")
      assert {:error, {:internal_server_error, "MS_UNAVAILABLE"}} == response
    end
  end

  describe "when service times out," do
    setup :timeout

    test "return internal_server_error with provided reason" do
      response = Viex.lookup("SE12345689")
      assert {:error, {:internal_server_error, "TIMEOUT"}} == response
    end
  end

  describe "when service reaches global max number of concurrent requests," do
    setup :global_max_concurrent

    test "return internal_server_error with provided reason" do
      response = Viex.lookup("SE12345689")
      assert {:error, {:internal_server_error, "GLOBAL_MAX_CONCURRENT_REQ"}} == response
    end
  end

  describe "when service reaches max number of concurrent requests for a member state," do
    setup :ms_max_concurrent

    test "return internal_server_error with provided reason" do
      response = Viex.lookup("SE12345689")
      assert {:error, {:internal_server_error, "MS_MAX_CONCURRENT_REQ"}} == response
    end
  end

  describe "when service is unavailable," do
    setup :service_unavailable

    test "return internal_server_error with provided reason" do
      response = Viex.lookup("SE12345689")
      assert {:error, {:internal_server_error, "SERVICE_UNAVAILABLE"}} == response
    end
  end

  defp ms_unavailable(_), do: error_helper("MS_UNAVAILABLE")
  defp timeout(_), do: error_helper("TIMEOUT")
  defp global_max_concurrent(_), do: error_helper("GLOBAL_MAX_CONCURRENT_REQ")
  defp ms_max_concurrent(_), do: error_helper("MS_MAX_CONCURRENT_REQ")
  defp service_unavailable(_), do: error_helper("SERVICE_UNAVAILABLE")

  defp error_helper(reason) do
    expect(Viex.Http, :post,
      fn(_url, _body, _headers, _params) ->
        {:ok, %HTTPoison.Response{status_code: 200,
                                  body: error(reason)}}
      end)
    :ok
  end

  defp error(reason) do
    ~s(<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <soap:Fault>
            <faultcode>soap:Server</faultcode>
            <faultstring>#{reason}</faultstring>
          </soap:Fault>
      </soap:Body>
    </soap:Envelope>)
  end
end
