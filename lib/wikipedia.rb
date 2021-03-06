module Wikipedia
  SOURCE_PREFIX = "https://en.wikipedia.org/w/index.php?action=raw&title="

  class << self
    def football_kits(article_url)
      input = fetch(article_url) or return
      Extractor.extract(input)
    end

    def fetch(article_url)
      input = source(article_url) or return
      Parser.parse(input)
    end

    def source(article_url)
      url = source_url(article_url) or return
      response = Faraday.get(url)

      return unless response.success?
      response.body
    end

    def source_url(article_url)
      title = title(article_url) or return
      [SOURCE_PREFIX, title].join
    end

    def title(article_url)
      uri = URI.parse(article_url)
      uri.path.split("/").last
    rescue URI::InvalidURIError
      nil
    end
  end
end
