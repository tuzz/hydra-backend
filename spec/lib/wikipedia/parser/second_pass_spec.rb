RSpec.describe Wikipedia::Parser::SecondPass do
  def parse(input)
    described_class.parse(input)
  end

  def template(name, params = {})
    Wikipedia::Template.new(name: name, params: params)
  end

  it "parses simple templates" do
    expect(parse([["a"]])).to eq [template("a")]
    expect(parse([["a"], ["b"]])).to eq [template("a"), template("b")]
  end

  it "parses templates with named params" do
    expect(parse([["a|b=c"]])).to eq [template("a", "b" => "c")]
    expect(parse([["a|b=c|d=e"]])).to eq [template("a", "b" => "c", "d" => "e")]
    expect(parse([["a|b="]])).to eq [template("a", "b" => "")]
  end

  it "parses templates with nameless params" do
    expect(parse([["a|b"]])).to eq [template("a", "1" => "b")]
    expect(parse([["a|b|c"]])).to eq [template("a", "1" => "b", "2" => "c")]

    expect(parse([["a|b"], ["c|d"]])).to eq [
      template("a", "1" => "b"), template("c", "1" => "d")]
  end

  it "strips whitespace around named params" do
    expect(parse([["a| b=c "]])).to eq [template("a", "b" => "c")]
    expect(parse([["a| b = c "]])).to eq [template("a", "b" => "c")]
    expect(parse([["a| b c = d e"]])).to eq [template("a", "b c" => "d e")]
  end

  it "does not strip whitespace around nameless params" do
    expect(parse([["a| b "]])).to eq [template("a", "1" => " b ")]
    expect(parse([["a| \t b c \n"]])).to eq [template("a", "1" => " \t b c \n")]
  end

  it "parses templates with mixed params" do
    expect(parse([["a|b|c=d"]])).to eq [template("a", "1" => "b", "c" => "d")]
    expect(parse([["a|b=c|d"]])).to eq [template("a", "b" => "c", "1" => "d")]
  end

  it "parses nested templates" do
    expect(parse([["a|", ["b"]]])).to eq [template("a", "1" => [template("b")])]

    expect(parse([["a|b=", ["c"]]])).to eq [
      template("a", "b" => [template("c")])]
  end

  it "parses nested templates inside strings" do
    expect(parse([["a|b", ["c"], "d"]])).to eq [
      template("a", "1" => ["b", template("c"), "d"])]

    expect(parse([["a|b=c", ["d"], "e"]])).to eq [
      template("a", "b" => ["c", template("d"), "e"])]
  end

  it "parses nested templates alongside other params" do
    expect(parse([["a|", ["b"], "|c"]])).to eq [
      template("a", "1" => [template("b")], "2" => "c")]

    expect(parse([["a|", ["b"], "|c|", ["d"]]])).to eq [
      template("a", "1" => [template("b")], "2" => "c", "3" => [template("d")])]
  end

  it "parses nested templates with params" do
    expect(parse([["a|", ["b|c"]]])).to eq [
      template("a", "1" => [template("b", "1" => "c")])]

    expect(parse([["a|b=", ["c|d=e"]]])).to eq [
      template("a", "b" => [template("c", "d" => "e")])]
  end

  it "parses deeply nested templates" do
    expect(parse([["a|", ["b|", ["c"]]]])).to eq [
      template("a", "1" => [template("b", "1" => [template("c")])])]

    expect(parse([["a|b=", ["c|d=", ["e|f=g"]]]])).to eq [
      template("a", "b" => [template("c", "d" => [template("e", "f" => "g")])])]
  end
end
