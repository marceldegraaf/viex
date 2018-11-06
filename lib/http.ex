defmodule Viex.Http.Behaviour do
  @type headers :: [{binary, binary}] | %{binary => binary}
  @type body :: binary | {:form, [{atom, any}]} | {:file, binary}

  @callback post(binary, body, headers, Keyword.t) :: {:ok, Response.t} | {:error, Error.t}
end

defmodule Viex.Http do

  @behaviour Viex.Http.Behaviour

  defdelegate post(url, body, headers, opts), to: HTTPoison
end
