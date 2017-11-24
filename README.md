# ExFieldDoc

Create `defstruct` field documentation inline.

This is a proof-of-concept to understand how documentation for fields in `defstruct` could
be generated from inlined strings.

## Usage

```elixir
defmodule Sample do
  use ExFieldDoc

  defstruct [
    :undocumented,
    :documented || "documented",
    {:documented_with_default, 1} || "documented"
  ]
end
```

With `use ExFieldDoc`, the `defstruct` macro is overwritten. Upon calling `defstruct`,
ExFieldDoc walks the fields and generates a `@doc` annotation (`Module.add_doc/5`) from
those fields which are documented with `|| string`.

## Pitfalls

Note that the following is not possible:

```elixir
defstruct [
    field: :default || "This does not work"
]
```

When using default values, one MUST use tuples.
