module TheLibrary
  class Book
    attr_accessor :title, :author, :price, :shippingweight, :isbn10
    def initialize(title, author, price, shippingweight, isbn10)
      @title = title
      @author = author
      @price = price
      @shippingweight = shippingweight
      @isbn10 = isbn10
    end
  end
end