defmodule ReadlyTest do
  use ExUnit.Case
  doctest Readly

  defmodule Language do
    use Readly, struct: %{en: "", ja: "", id: nil}

    readonly %{en: "english",  ja: "英語",   id: 1}, :english
    readonly %{en: "chinese",  ja: "中国語", id: 2}, "chinese"
    readonly %{en: "japanese", ja: "日本語", id: 3}, :japanese
  end

  defmodule User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field :name, :string
      field :language, Language
    end

    def changeset(user, params \\ :invalid) do
      user
      |> cast(params, ~w(name language), ~w())
    end
  end

  test "ensure build struct" do
    assert %Language{id: nil} == %Language{en: "", ja: "", id: nil}
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

  test "it can cast integer to custom type" do
    assert Language.cast(1) == {:ok, Language.english}
  end

  test "it can cast figures to custom type" do
    assert Language.cast("3") == {:ok, Language.japanese}
  end

  test "it can cast custom type to custom type" do
    assert Language.cast(Language.english) == {:ok, Language.english}
  end

  test "it can not cast any other to custom type" do
    assert Language.cast("string") == :error
    assert Language.cast(nil) == :error
    assert Language.cast(2.0) == :error
    assert Language.cast(:english) == :error
  end

  test "it can load datasource from integer " do
    assert Language.load(1) == {:ok, Language.english}
  end

  test "it can not load datasource from invalid id" do
    assert Language.load(1000) == :error
  end

  test "it can not load datasource from any other " do
    assert Language.load("2") == :error
    assert Language.load(nil) == :error
    assert Language.load(%{}) == :error
  end

  test "it can dump datasource" do
    assert Language.dump(Language.english) == {:ok, 1}
  end

  test "it can not dump any other" do
    assert Language.dump(2) == :error
    assert Language.dump(nil) == :error
    assert Language.dump(2.9) == :error
    assert Language.dump(%{}) == :error
  end

  test "it can build a changeset with no errors by datasource struct" do
    cs = User.changeset(%User{}, %{name: "igrs", language: Language.japanese})
    assert cs.errors == []
  end

  test "it can build a changeset with no errors by datasource id" do
    cs = User.changeset(%User{}, %{name: "igrs", language: 1})
    assert cs.errors == []
  end

  test "it can build a changeset with no errors by datasource id string" do
    cs = User.changeset(%User{}, %{name: "igrs", language: "1"})
    assert cs.errors == []
  end

  test "it can not build a changeset with no errors by nil" do
    cs = User.changeset(%User{}, %{name: "igrs", language: nil})
    assert cs.errors != []
  end

  test "it can not build a changeset with no errors by invalid id" do
    cs = User.changeset(%User{}, %{name: "igrs", language: 5})
    assert cs.errors == [language: "is invalid"]
  end

  test "ensure options function" do
    assert Language.options(:ja, :id) == [{"英語", 1}, {"中国語", 2}, {"日本語", 3}]
  end
end
