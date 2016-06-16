defmodule ReadlyTest do
  use ExUnit.Case
  doctest Readly

  defmodule Language do
    use Readly, struct: %{en: "", ja: "", id: nil}

    readonly %{en: "english",  ja: "英語",   id: 1}, :english
    readonly %{en: "chinese",  ja: "中国語", id: 2}, "chinese"
    readonly %{en: "japanese", ja: "日本語", id: 3}, :japanese
  end

  test "ensure build struct" do
    assert %Language{} == %Language{en: "", ja: "", id: nil}
  end

  test "automatic created function: english" do
    assert Language.english == %Language{en: "english",  ja: "英語",   id: 1}
  end

  test "automatic created function: chinese" do
    assert Language.chinese == %Language{en: "chinese",  ja: "中国語", id: 2}
  end

  test "automatic created function: japanese" do
    assert Language.japanese == %Language{en: "japanese", ja: "日本語", id: 3}
  end

  test "ensure all datasource function" do
    assert Language.all == [
      %Language{en: "english",  ja: "英語",   id: 1},
      %Language{en: "chinese",  ja: "中国語", id: 2},
      %Language{en: "japanese", ja: "日本語", id: 3}
    ]
  end

  test "ensure reverse datasource function" do
    assert Language.reverse == [
      %Language{en: "japanese", ja: "日本語", id: 3},
      %Language{en: "chinese",  ja: "中国語", id: 2},
      %Language{en: "english",  ja: "英語",   id: 1}
    ]
  end

  test "ensure get function" do
    assert Language.japanese == Language.get(3)
    assert Language.chinese == Language.get(2)
  end

  test "ensure get function when unknown id" do
    assert nil == Language.get(5)
  end
end
