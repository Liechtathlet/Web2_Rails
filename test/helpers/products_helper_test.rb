require 'test_helper'

class ProductsHelperTest < ActionView::TestCase
  
   test "format chf" do
    assert_equal "CHF 5.5", format_chf(5.50)
    assert_equal "CHF 5", format_chf(5)
  end
end
