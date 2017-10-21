RSpec.describe Wikipedia do
  def template(name, params = {})
    Wikipedia::Template.new(name: name, params: params)
  end

  describe ".fetch" do
    before do
      url = "https://en.wikipedia.org/w/index.php?action=raw&title=Tuzz_F.C."
      stub_request(:get, url).to_return(body: <<-BODY)
        Player lineup:
        {{Player|name=tuzz|height={{centimetres|177}} tall}}

        Kit:
        {{Football kit
          | left_arm=red
          | right_arm=red
          | chest=black
          | chest= {{hex|#000}}}}

        Trophies:
        {{Trophy cabinet|url=[[wikipedia.com|Tuzz_F.C.|Trophies]]}}
      BODY

      url = "https://en.wikipedia.org/w/index.php?action=raw&title=missing"
      stub_request(:get, url).to_return(status: 404)
    end

    it "returns wikipedia templates parsed from the article's source" do
      result = subject.fetch("https://en.wikipedia.org/wiki/Tuzz_F.C.")

      expect(result).to eq [
        "Player lineup:",
        template("Player",
          "name" => "tuzz",
          "height" => [template("centimetres", "1" => "177"), "tall"],
        ),
        "Kit:",
        template("Football kit",
          "left_arm" => "red",
          "right_arm" => "red",
          "chest" => [template("hex", "1" => "#000")],
        ),
        "Trophies:",
        template("Trophy cabinet",
          "url" => [template("link:wikipedia.com",
             "1" => "Tuzz_F.C.",
             "2" => "Trophies",
          )],
        ),
      ]
    end

    it "returns nil if the url is invalid" do
      result = subject.fetch("#something#invalid")
      expect(result).to be_nil
    end

    it "returns nil if the page doesn't exist" do
      result = subject.fetch("https://en.wikipedia.org/wiki/missing")
      expect(result).to be_nil
    end
  end

  describe ".source" do
    before do
      url = "https://en.wikipedia.org/w/index.php?action=raw&title=Tuzz_F.C."
      stub_request(:get, url).to_return(body: "the article's source markup")

      url = "https://en.wikipedia.org/w/index.php?action=raw&title=missing"
      stub_request(:get, url).to_return(status: 404)
    end

    it "returns the source for an article" do
      result = subject.source("https://en.wikipedia.org/wiki/Tuzz_F.C.")
      expect(result).to eq("the article's source markup")
    end

    it "returns nil if the url is invalid" do
      result = subject.source("#something#invalid")
      expect(result).to be_nil
    end

    it "returns nil if the page doesn't exist" do
      result = subject.source("https://en.wikipedia.org/wiki/missing")
      expect(result).to be_nil
    end
  end

  describe ".source_url" do
    it "returns the url to the source page for a title" do
      result = subject.source_url("https://en.wikipedia.org/wiki/Tuzz_F.C.")
      expect(result).to eq("https://en.wikipedia.org/w/index.php?action=raw&title=Tuzz_F.C.")
    end

    it "returns nil if the url is invalid" do
      result = subject.source_url("#something#invalid")
      expect(result).to be_nil
    end
  end

  describe ".title" do
    it "returns the title of an article from the url" do
      result = subject.title("https://en.wikipedia.org/wiki/Tuzz_F.C.")
      expect(result).to eq("Tuzz_F.C.")
    end

    it "ignores query parameters" do
      result = subject.title("https://en.wikipedia.org/wiki/Tuzz_F.C.?key=val")
      expect(result).to eq("Tuzz_F.C.")
    end

    it "ignores anchors" do
      result = subject.title("https://en.wikipedia.org/wiki/Tuzz_F.C.#anchor")
      expect(result).to eq("Tuzz_F.C.")
    end

    it "returns nil if the url is invalid" do
      result = subject.title("#something#invalid")
      expect(result).to be_nil
    end
  end
end
