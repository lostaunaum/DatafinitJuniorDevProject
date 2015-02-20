# This is the ORM file, in this file I communicate with the postgres database. I have created a database called test and a table within it called book_objects.

require 'pg'
require 'pry-byebug'

module TheLibrary
  module Repos
    class BookLog

      def initialize
        @db = PG.connect(host: 'localhost', dbname: 'test')
        create_destroy_table
      end

      def create_destroy_table
       @db.exec(%q[
         DROP TABLE IF EXISTS book_objects
         ])
        @db.exec(%q[
         CREATE TABLE IF NOT EXISTS book_objects(
           title text,
           author text,
           price text,
           shippingweight text,
           isbn10 text
           )
         ])
      end

      def book_log
        result = @db.exec('SELECT * FROM book_objects;')
        build_request(result.entries)
      end

      def create_new_book(book_object)
        result = @db.exec(%q[
          INSERT INTO book_objects (title, author, price, shippingweight, isbn10)
          VALUES ($1, $2, $3, $4, $5) 
          RETURNING title, author, price, shippingweight, isbn10;
        ], [book_object.title, book_object.author, book_object.price, book_object.shippingweight, book_object.isbn10])
        result.entries.first
      end
    
      def build_request(entries)
        entries.map do |book_hash|
          x = TheLibrary::Book.new(book_hash["title"], book_hash["author"], book_hash["price"], book_hash["shippingweight"], book_hash["isbn10"].to_i)
          x.instance_variable_set :@title, book_hash["title"]
          x.instance_variable_set :@author, book_hash["author"]
          x.instance_variable_set :@price, book_hash["price"]
          x.instance_variable_set :@shippingweight, book_hash["shippingweight"]
          x.instance_variable_set :@isbn10, book_hash["isbn10"].to_i
          x
        end
      end

    end
  end 
end
