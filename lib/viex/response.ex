defmodule Viex.Response do
  alias Viex.Parser

  @moduledoc """
  Parses and represents a VIES SOAP response.
  """

  defstruct valid: false, company: nil, address: nil

  @doc """
  Parses a raw VIES SOAP response into a `Viex.Response` struct.
  """
  @spec parse({atom, String.t()}) :: map | {:error, String.t()}
  def parse({:error, reason}), do: {:error, reason}

  def parse({:ok, body}) do
    %Viex.Response{
      valid: Parser.parse_validity(body),
      company: Parser.parse_field(body, "name"),
      address: Parser.parse_field(body, "address")
    }
  end
end
