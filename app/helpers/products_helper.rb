module ProductsHelper
  
  def format_chf(amount)
    "CHF %05.2f" % amount
  end
end
