require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  # this class will handle the scraping part
  
  @@index = "http://stackoverflow.com/questions/tagged"

  attr_accessor :tag, :index, :discussion_urls

  def initialize(tag="ruby")
    @tag = tag
    @index = "#{@@index}/#{self.tag}?sort=votes&pageSize=50"
  end

  def scrape
    url = open(self.index)
    noko_doc = Nokogiri::HTML(url)
    self.discussion_urls = noko_doc.css(".summary h3 a").map do |link|
      "http://stackoverflow.com#{link.attr('href')}"
    end
  end

  def make_discussions
    self.discussion_urls.each do |url|
      Discussion.new(url)
    end
  end

  def create_discussions
    self.scrape
    self.make_discussions
  end

end