defmodule Viex.Response do
  defstruct valid: nil, company: nil, address: nil

  def parse(body) do
    %Viex.Response{
      valid: valid(body),
      company: company(body),
      address: address(body)
    }
  end

  defp valid(body), do: Floki.find(body, "valid") |> Floki.text

  defp company(body), do: Floki.find(body, "name") |> Floki.text

  defp address(body) do
    Floki.find(body, "address")
    |> Floki.text
    |> String.strip
  end
end
