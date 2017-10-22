RSpec.describe Wikipedia::Extractor do
  def extract(input)
    described_class.extract(input)
  end

  def template(name, params = {})
    Wikipedia::Template.new(name: name, params: params)
  end

  def params(keys)
    keys.map { |k| [k, k] }.to_h
  end

  def numbered(array, number)
    array.map { |e| [e, number].join }
  end

  def duplicate(array, n)
    1.upto(n).flat_map { |i| numbered(array, i) }
  end

  let(:football_kit_keys) { described_class::FOOTBALL_KIT_KEYS }
  let(:football_club_keys) { described_class::FOOTBALL_CLUB_KEYS }

  let(:football_kit_params) { params(football_kit_keys) }
  let(:football_club_params) { params(duplicate(football_club_keys, 3)) }

  def matched_up_params(n)
    football_kit_keys.zip(numbered(football_club_keys, n)).to_h
  end

  it "extracts 'Football kit'" do
    input = template("Football kit", football_kit_params)
		expect(extract(input)).to eq [template("Football kit", football_kit_params)]
  end

  it "ignores additional params" do
    params = football_kit_params.merge("foo" => "bar")
    input = template("Football kit", params)
		expect(extract(input)).to eq [template("Football kit", football_kit_params)]
  end

  it "extract 'Football kit' from 'Infobox football club'" do
		input = template("Infobox football club", football_club_params)

    expect(extract(input)).to eq [
      template("Football kit", matched_up_params(1)),
      template("Football kit", matched_up_params(2)),
      template("Football kit", matched_up_params(3)),
    ]
  end

  it "sets missing params to nil" do
    params = football_club_params.without("shorts1")
		input = template("Infobox football club", params)

    expect(extract(input).first).to eq(template("Football kit",
      matched_up_params(1).merge("shorts" => nil)))
  end
end
