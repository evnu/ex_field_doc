defmodule ExFieldDoc do
  @moduledoc """
  Documenting `defstruct` fields inline.

  ## Usage

  `ExFieldDoc` adds function documentation which includes fields and their corresponding
  default values (if any). Fields are marked to be documented by appending `||` followed
  by a string. See the example below and note that keywords cannot be used when using `||`.

  ```
  defmodule Test do
    use ExFieldDoc # note: imports `Kernel`, except `defstruct/1`

    defstruct [
      :undocumented, # This is an undocumented field
      :documented || "Documented field with default `nil`",
      {:with_default, 1} || "Documented field with default `1`"
      does_not_work: 2 || "Does not work due to operator precendence"
    ]
  end
  ```
  """

  defmodule FieldDoc do
    @moduledoc false
    defstruct [:field, :default, :doc]
  end

  defmacro defstruct(fields) do
    {fields, doc} = split(fields)
    quote do
      Module.add_doc(__MODULE__, __ENV__.line, :def, {:__struct__, 0}, [], unquote(doc))
      Kernel.defstruct(unquote(fields))
    end
  end

  defmacro __using__(_) do
    m = __MODULE__
    quote do
      import Kernel, except: [defstruct: 1]
      import unquote(m)
    end
  end

  defp split(fields) do
    {fields, field_docs} =
      fields
      |> Enum.map(&separate_doc_strings/1)
      |> Enum.unzip()
    {fields, to_doc(field_docs)}
  end

  defp separate_doc_strings({:||, _line, [inner, doc]}) do
    {inner, %FieldDoc{field: field(inner), default: default(inner), doc: doc}}
  end
  defp separate_doc_strings(other), do: {other, nil}

  defp field(field) when is_atom(field), do: field
  defp field({field, _value}) when is_atom(field), do: field

  defp default(field) when is_atom(field), do: nil
  defp default({_field, value}), do: {:default, value}

  defp to_doc(field_docs) do
    docs =
      for %FieldDoc{field: field, default: default, doc: doc} <- field_docs do
        default_str =
          case default do
            nil ->
              ""
            {:default, default} ->
              "(default: #{inspect default})"
          end
        "* `#{field}`: #{doc}#{default_str}"
      end |> Enum.join("\n")
    """
    Fields documentation.

    #{docs}
    """
  end
end
