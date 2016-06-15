defmodule ReadlyTest do
  use ExUnit.Case
  doctest Readly

  defmodule Mock do
    use Readly, struct: %{en: "", ja: "", id: nil}

    read_only %{en: "english",  ja: "英語",   id: 1}, :english
    read_only %{en: "chinese",  ja: "中国語", id: 2}, :chinese
    read_only %{en: "japanese", ja: "日本語", id: 3}, :japanese
  end

  test "english" do
    assert Mock.english == %Mock{en: "english",  ja: "英語",   id: 1}
  end


  test "struct" do
    assert %Mock{} == %Mock{en: "", ja: "", id: nil}
  end
end
