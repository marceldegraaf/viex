defmodule Viex.Response do
  @moduledoc """
  Parses and represents a VIES SOAP response.
  """

  defstruct valid: false, company: nil, address: nil

  @doc """
  Parses a raw VIES SOAP response into a `Viex.Response` struct.
  """
  @spec parse({atom, String.t}) :: map | {:error, String.t}
  def parse({:error, reason}), do: {:error, reason}
  def parse({:ok, body}) do
    %Viex.Response{
      valid: parse_validity(body),
      company: parse_company(body),
      address: parse_address(body)
    }
  end

  defp parse_validity(body) do
    valid =
      body
      |> Floki.find("valid")
      |> Floki.text
      |> String.trim

    case valid do
      "true" -> true
      ""     -> false
      _      -> false
    end
  end

  defp parse_company(body) do
    company =
      body
      |> Floki.find("name")
      |> Floki.text
      |> String.trim

    case company do
      ""      -> nil
      company -> company
    end
  end

  defp parse_address(body) do
    address =
      body
      |> Floki.find("address")
      |> Floki.text
      |> String.trim

    case address do
      ""      -> nil
      address -> address
    end
  end
end
