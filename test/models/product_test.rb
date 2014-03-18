require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  def new_product(image_url)
    Product.new(title: "This title is long enough ",
    description: "XYZ",
    price: 1,
    image_url: image_url)
  end
  
  def new_product_with_title(myTitle)
    Product.new(title: myTitle,
    description: "XYZ",
    price: 1,
    image_url: 'fred.gif')
  end

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any? 
    assert product.errors[:price].any? 
  end
  
  test "product price must be positive" do
    product = Product.new(title: "My Book with a long long title",
                          description: "XYZ",
                          image_url: "MyBook.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.05"], product.errors[:price]
    
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.05"], product.errors[:price]
    
    product.price = 1
    assert product.valid?
  end
  
  test "product price must be rounded to x.y5 or x.y0" do
    product = Product.new(title: "My Book 3 with a long long title",
                          description: "XYZ",
                          image_url: "MyBook.jpg")
    product.price = 5.23
    assert product.invalid?
    assert_equal ["muss auf 5 Rappen gerundet werden."], product.errors[:price]
    
    product.price = 5.98
    assert product.invalid?
    assert_equal ["muss auf 5 Rappen gerundet werden."], product.errors[:price]
    
    product.price = 1
    assert product.valid?
    
     product.price = 5.05
    assert product.valid?
    
     product.price = 10.60
    assert product.valid?
  end
  
  test "image url" do
    ok = %w{ fred.png fred.gif fred.jpg fred.jpeg FRED.Jpg http://a.b.c/x/y/z/fred.jpeG}
    bad = %w{ fred.doc fred.bmp fed.gif.more fred.gif/more fred.gife}
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "Something...",
                          price: 1,
                          image_url: "fred.png")
                          
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
  
  test "product title must be at least 10 characters long" do
    bad = ["ABCD","ABCDEFGHI","My_Title"]
    ok = ["ABCDEFGHIJ","LangerTitel"]

    ok.each do |title|
      assert new_product_with_title(title).valid?, "#{title} should be valid"
    end
    
    bad.each do |title|
      assert new_product_with_title(title).invalid?, "#{title} shouldn't be valid"
    end
  end
end
