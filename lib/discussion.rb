require 'pry'
require 'nokogiri'
require 'open-uri'

class Discussion

  URLs = []
  @@id = 1

  def self.urls
    URLs
  end

  attr_reader :url, :question, :upvotes,
              :noko_doc, :op_name, :op_url,
              :id

  attr_accessor :saved

  def initialize(url, id=nil)
    if !id
      @id = @@id
      @@id += 1
    else
      @id = id
    end
    @saved = false
    @url = url
    URLs << self.url
    set_default_values
    save
  end

  def set_default_values
    @noko_doc = create_noko_doc
    @question = get_discussion_question
    @upvotes = get_total_upvotes
    @op_name = get_op_name
    @op_url = get_op_url
  end

  def save
    Database.save(self)
  end

  def saved?
    self.saved
  end

  def create_noko_doc
    Nokogiri::HTML(get_html)
  end
  
  def get_html
    open(self.url)
  end

  def get_discussion_question
    self.noko_doc.css('#question-header a').text
  end

  def get_total_upvotes
    self.noko_doc.at_css(".vote-count-post").text.to_i
  end

  def get_op_name
    op_name_node = self.noko_doc.at_css(".owner .user-details a")
    if op_name_node
      op_name_node.text
    else
      "community wiki"
    end
  end

  def get_op_url
    op_url_node = self.noko_doc.at_css(".owner .user-details a")
    if op_url_node
      "http://stackoverflow.com#{op_url_node.attr('href')}"
    else
      "community wiki"
    end
  end

  def self.reset_urls
    URLs.clear
  end
end