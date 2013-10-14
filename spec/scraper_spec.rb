require_relative 'spec_helper'
require 'pry'

describe Scraper do

  let(:tag) { "javascript" }
  let(:scraper) { Scraper.new }
  let(:scraper2) { Scraper.new(tag)}

  it "is an instance of its own class, derp" do
    scraper.should be_a(Scraper)
  end

  it "should default to the 'ruby' tag" do
    scraper.tag.should eq("ruby")
  end

  it "should accept non-'ruby' tags on initialization" do
    scraper2.tag.should_not eq("ruby")
    scraper2.tag.should eq("javascript")
  end
  
  it "instances should have an index url pointing to the tag" do
    scraper.index.should eq("http://stackoverflow.com/questions/tagged/ruby?sort=votes&pageSize=50")
    scraper2.index.should eq("http://stackoverflow.com/questions/tagged/#{tag}?sort=votes&pageSize=50")
  end

  context "#scrape" do
    it "should have a scrape method" do
      scraper.should respond_to(:scrape)
    end

    it "should return an array of top 50 discussion urls based on the tag" do
      scraper.scrape.should be_a(Array)
      scraper.scrape.size.should eq(50)
      scraper.scrape.first.should be_a(String)
    end
  end

  context "#create_discussions" do
    it "should make new Discussion instances" do
      Discussion.should_receive(:new).exactly(50).times
      scraper.create_discussions # this should create 50 new Discussions with unique URLs  
    end

    it "should create Discussion instances with unique URLs" do
      Discussion.reset_urls
      scraper.create_discussions
      scraper.discussion_urls.should eq(Discussion.urls)
    end
  end

end