defmodule ExFieldDocTest do
  use ExUnit.Case
  doctest ExFieldDoc

  defmodule Sample do
    use ExFieldDoc

    defstruct [
      :undocumented,
      :documented || "documented",
      {:documented_with_default, 1} || "documented"
    ]
  end

  test "can use fields" do
    s = %Sample{}
    assert nil == s.undocumented
    assert nil == s.documented
    assert 1 == s.documented_with_default
  end

  test "can create from list" do
    args = [
      undocumented: 1,
      documented: 2,
      documented_with_default: 3
    ]

    s = struct(Sample, args)
    assert 1 == s.undocumented
    assert 2 == s.documented
    assert 3 == s.documented_with_default
  end
end
