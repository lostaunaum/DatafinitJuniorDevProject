# this is the testing page here we test to see if we are actually creating a hash with the information scrapped, that the ruby object is created and that we can store it within the database

require_relative '../lib/data_finiti_project.rb'
require 'pry-byebug'

describe TheLibrary::Repos::BookLog do
  before(:each) do
    TheLibrary::Repos::BookLog.new.create_destroy_table
    @book_url_book1 = 'http://www.amazon.com/gp/product/1465419659/ref=s9_simh_bw_p14_d0_i2?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=merchandised-search-3&pf_rd_r=1ZN2T98HFN4HB0RXNMGJ&pf_rd_t=101&pf_rd_p=1975016422&pf_rd_i=283155'
    @book_url_book2 = 'http://www.amazon.com/Zealot-Life-Times-Jesus-Nazareth/dp/140006922X/ref=tmm_hrd_title_0?_encoding=UTF8&sr=8-1&qid=1424381988'
    @book_url_book3 = "http://www.amazon.com/Mice-Men-John-Steinbeck/dp/0140177396/ref=sr_1_1?s=books&ie=UTF8&qid=1424430724&sr=1-1&keywords=mice+and+men"
  end

  it "can scrape the required information from a URL and create a hash" do 
    scraped_info = (TheLibrary.book_controller.scraping_website(@book_url_book1))
    new_book_hash =  (TheLibrary.book_controller.building_url_hash(scraped_info))
    expect(new_book_hash.class).to eq(Hash)
  end

  it "it can create a ruby book object from the infromation of the hash" do 
    # scraping the url to create the hash
    scraped_info = (TheLibrary.book_controller.scraping_website(@book_url_book1))
    new_book_hash =  (TheLibrary.book_controller.building_url_hash(scraped_info))
    # creating the ruby object
    new_book_ruby_object = (TheLibrary.book_controller.creating_the_ruby_book_object(new_book_hash))

    expect(new_book_ruby_object.class).to eq(TheLibrary::Book)
  end

  it "can save a book object in the postgresql database" do 
    # scraping the information from the URL's
    scraped_info1 = (TheLibrary.book_controller.scraping_website(@book_url_book1))
    scraped_info2 = (TheLibrary.book_controller.scraping_website(@book_url_book2))

    new_book_hash1 = (TheLibrary.book_controller.scraping_website(scraped_info1))
    new_book_hash2 = (TheLibrary.book_controller.scraping_website(scraped_info2))
    
    # creating the ruby objects
    new_book_ruby_object1 = (TheLibrary.book_controller.creating_the_ruby_book_object(new_book_hash1))
    new_book_ruby_object2 = (TheLibrary.book_controller.creating_the_ruby_book_object(new_book_hash2))

    # saving books in database
    TheLibrary.book_controller.saving_book_object(new_book_ruby_object1)
    TheLibrary.book_controller.saving_book_object(new_book_ruby_object2)
    
    # expect only 2 entries within the database
    expect(TheLibrary.book_ORM.book_log.length).to eq(2)
  end

end