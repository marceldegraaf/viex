# Viex

[![Build Status](https://semaphoreci.com/api/v1/marceldegraaf/viex/branches/master/shields_badge.svg)](https://semaphoreci.com/marceldegraaf/viex)
[![Coverage Status](https://coveralls.io/repos/github/marceldegraaf/viex/badge.svg?branch=master)](https://coveralls.io/github/marceldegraaf/viex?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/viex.svg)](https://hex.pm/packages/viex)
[![Hex.pm](https://img.shields.io/hexpm/l/viex.svg)](https://hex.pm/packages/viex)

Elixir package to validate European VAT numbers with the
[VIES](http://ec.europa.eu/taxation_customs/vies/) service.

## Installation

Add `viex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:viex, "~> 0.1.0"}]
end
```

## Error scenarios described by the WSDL

From the service WSDL we know these possible error reasons


| Fault String | Meaning | Suggested recovery |
| -------------| --------| ------------------ |
| GLOBAL_MAX_CONCURRENT_REQ |  Your Request for VAT validation has not been processed; the maximum number of concurrent requests has been reached. Please re-submit your request later or contact TAXUD-VIESWEB@ec.europa.eu for further information": Your request cannot be processed due to high traffic on the web application. | Try again later |
| MS_MAX_CONCURRENT_REQ |  Your Request for VAT validation has not been processed; the maximum number of concurrent requests for this Member State has been reached. Please re-submit your request later or contact TAXUD-VIESWEB@ec.europa.eu for further information": Your request cannot be processed due to high traffic towards the Member State you are trying to reach. | Try again later |
| SERVICE_UNAVAILABLE |  An error was encountered either at the network level or the Web application level | Try again later
| MS_UNAVAILABLE |  The application at the Member State is not replying or not available. Please refer to the Technical Information page to check the status of the requested Member State. | Try again later |
| TIMEOUT | The application did not receive a reply within the allocated time period | Try again later |

## Usage

Use `Viex.lookup/1` to look up a European VAT number. Returns a `Viex.Response`
struct containing the company name, address, and a `valid` key that is either
`true` or `false`.

    iex(1)> Viex.lookup("NL854265259B01")
    %Viex.Response{address: "PRINS BERNHARDPLEIN 00200\n1097JB AMSTERDAM", company: "GITHUB B.V.",
      valid: true}

Use `Viex.valid?/1` to check the validity of a European VAT number. Returns a
boolean.

    iex(1)> Viex.valid?("NL854265259B01")
    true
