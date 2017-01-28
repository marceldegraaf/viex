# Viex

[![Build Status](https://semaphoreci.com/api/v1/marceldegraaf/viex/branches/master/badge.svg)](https://semaphoreci.com/marceldegraaf/viex)

Elixir package to validate European VAT numbers with the
[VIES](http://ec.europa.eu/taxation_customs/vies/) service.

## Installation

Add `viex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:viex, "~> 0.1.0"}]
end
```

## Usage

Use `Viex.lookup/1` to look up a European VAT number. Returns a `Viex.Response`
struct containing the company name, address, and a `valid` key that is either
`true` or `false`.

    iex(1)> Viex.lookup("NL188399277B01")
    %Viex.Response{address: "KERKSTRAAT 23\n1234AB FLEVOLAND", company: "Acme B.V.",
      valid: true}

Use `Viex.valid?/1` to check the validity of a European VAT number. Returns a
boolean.

    iex(1)> Viex.valid?("NL188399277B01")
    true
