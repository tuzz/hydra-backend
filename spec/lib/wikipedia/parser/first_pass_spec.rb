RSpec.describe Wikipedia::Parser::FirstPass do
  def parse(input)
    described_class.parse(input)
  end

  it "parses simple strings" do
    expect(parse("a")).to eq ["a"]
    expect(parse("a b")).to eq ["a b"]
  end

  it "strips surrounding whitespace" do
    expect(parse(" \t a b c \n ")).to eq ["a b c"]
  end

  it "parses templates within strings to nested arrays" do
    expect(parse("{{a}}")).to eq [["a"]]
    expect(parse("a {{b}}")).to eq ["a", ["b"]]
    expect(parse("a {{b}} {{c}}")).to eq ["a", ["b"], ["c"]]
    expect(parse("a {{ b {{c}} }}")).to eq ["a", ["b", ["c"]]]
    expect(parse("a {{{{b}}}}")).to eq ["a", [["b"]]]
    expect(parse("a{{b}}{{c}}{{d}}")).to eq ["a", ["b"], ["c"], ["d"]]
  end

  it "works over multiple lines" do
    expect(parse("a \n {{b}}")).to eq ["a", ["b"]]
    expect(parse("a {{ \n b }}")).to eq ["a", ["b"]]
  end

  it "parses wikipedia links as templates" do
    expect(parse("[[a]]")).to eq [["link:a"]]
    expect(parse("a{{b}}[[c]]{{d}}")).to eq ["a", ["b"], ["link:c"], ["d"]]
    expect(parse("a [[ b ]]")).to eq ["a", ["link:b"]]
  end
end
