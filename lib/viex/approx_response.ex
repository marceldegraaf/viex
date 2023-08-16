defmodule Viex.ApproxResponse do
  alias Viex.Parser

  @moduledoc """
  Parses and represents a VIES SOAP response requested with a requester VAT
  """

  defstruct valid: false,
            trader_name: nil,
            trader_company_type: nil,
            trader_address: nil,
            trader_street: nil,
            trader_postcode: nil,
            trader_city: nil,
            request_identifier: nil

  @doc """
  Parses a raw VIES SOAP response into a `Viex.ApproxResponse` struct.
  """
  @spec parse({atom, String.t()}) :: map | {:error, String.t()}
  def parse({:error, reason}), do: {:error, reason}

  def parse({:ok, body}) do
    %Viex.ApproxResponse{
      valid: Parser.parse_validity(body),
      trader_name: Parser.parse_field(body, "tradername"),
      trader_company_type: Parser.parse_field(body, "tradercompanytype"),
      trader_address: Parser.parse_field(body, "traderaddress"),
      trader_street: Parser.parse_field(body, "traderstreet"),
      trader_postcode: Parser.parse_field(body, "traderpostcode"),
      trader_city: Parser.parse_field(body, "tradercity"),
      request_identifier: Parser.parse_field(body, "requestidentifier")
    }
  end
end
