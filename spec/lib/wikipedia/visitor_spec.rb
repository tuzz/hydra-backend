RSpec.describe Wikipedia::Visitor do
  def visit(input)
    described_class.visit(input)
  end

  def template(name, params = {})
    Wikipedia::Template.new(name: name, params: params)
  end

  let(:foo) { template("foo") }
  let(:bar) { template("bar") }
  let(:baz) { template("baz", "foo" => foo) }
  let(:qux) { template("qux", "bar" => bar, "baz" => [baz]) }

  it "returns an enumerator" do
    expect(visit([])).to be_a(Enumerator)
  end

  it "yields templates at the top-level" do
    yielded = visit(foo).to_a
    expect(yielded).to eq [foo]
  end

  it "yields templates in arrays" do
    yielded = visit([foo, bar]).to_a
    expect(yielded).to eq [foo, bar]
  end

  it "yields templates in nested arrays" do
    yielded = visit([foo, [[bar]]]).to_a
    expect(yielded).to eq [foo, bar]
  end

  it "yields templates in params of other templates" do
    yielded = visit(qux).to_a
    expect(yielded).to match_array [foo, bar, baz, qux]
  end

  it "ignores things that aren't templates" do
    expect(visit(nil).to_a).to eq []
    expect(visit("foo").to_a).to eq []
    expect(visit(["foo", foo]).to_a).to eq [foo]
    expect(visit(visit(foo)).to_a).to eq []
  end
end
