defmodule Viex.Parser do
  @moduledoc false

  def parse_validity(body) do
    valid =
      body
      |> Floki.parse_document!()
      |> Floki.find("valid")
      |> Floki.text()
      |> String.trim()

    case valid do
      "true" -> true
      "" -> false
      _ -> false
    end
  end

  def parse_field(body, field) do
    body
    |> Floki.parse_document!()
    |> Floki.find(field)
    |> Floki.text()
    |> String.trim()
    |> case do
      "" -> nil
      field -> field
    end
  end
end
