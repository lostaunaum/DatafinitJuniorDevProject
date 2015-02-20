# this is the dependencies file, here I create the setter and getter methods for the ORM file and the controller. This project is designed thinking of the MVC pattern. Even though we dont have an active view we follow the MVC principles.

module TheLibrary

  # setter method for book ORM
  def self.book_ORM=(orm)
    @book_ORM = orm
  end

  # getter method for book ORM
  def self.book_ORM
    @book_ORM
  end

  # setter method for book ORM
  def self.book_controller=(controller)
    @book_controller = controller
  end

  # getter method for book ORM
  def self.book_controller
    @book_controller
  end

end

require_relative 'BookScraper/entities/book.rb'
require_relative 'BookScraper/databases/book_ORM.rb'
require_relative 'BookScraper/controllers/book_controller.rb'

TheLibrary.book_ORM = TheLibrary::Repos::BookLog.new
TheLibrary.book_controller = TheLibrary::Repos::BookController.new

