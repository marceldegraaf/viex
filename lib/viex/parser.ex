defmodule Viex.Parser do
  @moduledoc false

  def parse_validity(body) do
    valid =
      body
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
    |> Floki.find(field)
    |> Floki.text()
    |> String.trim()
    |> case do
      "" -> nil
      field -> field
    end
  end

  def handle_debug(body) do
    case debug_enabled?() do
      false ->
        nil
      true ->
        body
    end
  end

  defp debug_enabled?, do:  Application.get_env(:viex, :debug_enabled, false)
end
