# This is the controller of the project, i use this page to communicate with the URL's scrape the information needed, create hashes with that information and then create a ruby object with the hash. 

require 'mechanize'
require 'pry-byebug'

module TheLibrary
  module Repos
    class BookController

      def scraping_website(url)
        book_object_hash = {
          "box" => {
            "id" => 0,
            "totalWeight" => "",
            "contents" => {
              "title" => "",
              "author" => "",
              "price" => "",
              "shipping_weight" => "",
              "isbn-10" => ""
            }

          }
        }
        agent = Mechanize.new

        page_information = agent.get(url)

        # All these variables are needed in order to store the information scrapped from the URL we are using class and CSS selector to find the text we need in order to create our book object.
        title = page_information.search('#productTitle').text
        author = page_information.search('.contributorNameID').text
        price = page_information.search('.a-color-price.offer-price').text
        isbn = page_information.search(".content").at("b:contains('ISBN-10')").parent.text
        isbn = isbn.split(":")
        weight = page_information.search(".content").at("b:contains('Shipping Weight')").parent.text
        weight = weight.gsub("(View shipping rates and policies)", "").split(":")

        # Here is where we fill our has with all the information scraped
        book_object_hash["box"]["totalWeight"] = weight[1]
        book_object_hash["box"]["contents"]["title"] = title
        
        # Some of the books dont have a contributorNameID class placed for the authors name this happens when the Author is a publishing company.
        book_object_hash["box"]["contents"]["author"] = author
        if book_object_hash["box"]["contents"]["author"] == ""
          book_object_hash["box"]["contents"]["author"] = "Not Specified"
        end

        book_object_hash["box"]["contents"]["price"] = price
        book_object_hash["box"]["contents"]["shipping_weight"] = weight[1]
        book_object_hash["box"]["contents"]["isbn-10"] = isbn[1].to_i
        
        book_object_hash

        # Book.new(title, book_object["box"]["contents"]["author"], price, weight[1], isbn[1].to_i)
      end 

      def creating_the_ruby_book_object(hash)
        Book.new(hash["box"]["contents"]["title"], hash["box"]["contents"]["author"], hash["box"]["contents"]["price"], hash["box"]["contents"]["shipping_weight"], hash["box"]["contents"]["isbn-10"])
      end

      def saving_book_object(book)
        TheLibrary.book_ORM.create_new_book(book)
      end

    end
  end
end
