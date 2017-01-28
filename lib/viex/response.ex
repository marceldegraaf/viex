defmodule Viex.Response do
  defstruct valid: false, company: nil, address: nil

  @doc """
  Parses a raw VIES SOAP response into a `Viex.Response` struct.
  """
  @spec parse({atom, String.t}) :: map | {:error, String.t}
  def parse({:error, reason}), do: {:error, reason}
  def parse({:ok, body}) do
    %Viex.Response{
      valid: valid(body),
      company: company(body),
      address: address(body)
    }
  end

  defp valid(body) do
    valid =
      body
      |> Floki.find("valid")
      |> Floki.text
      |> String.strip

    case valid do
      "true" -> true
      ""     -> false
      _      -> false
    end
  end

  defp company(body) do
    company =
      body
      |> Floki.find("name")
      |> Floki.text
      |> String.strip

    case company do
      ""      -> nil
      company -> company
    end
  end

  defp address(body) do
    address =
      body
      |> Floki.find("address")
      |> Floki.text
      |> String.strip

    case address do
      ""      -> nil
      address -> address
    end
  end
end
