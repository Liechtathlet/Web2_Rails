class Product < ActiveRecord::Base
  validates :title, uniqueness: true
  validates :title, length: {minimum: 10}, allow_blank:true
  validates :title, :price, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.05}
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpe?g|png)\Z}i,
    message: 'must be a URL for GIF, JPG, JPEG or PNG image.'
  } 
  
  validate :validate_price_step
  
  # validates own business rules
  def validate_price_step
    if price != nil
      return if ((BigDecimal(price) * 100) % 5) == 0
      errors.add(:price, "muss auf 5 Rappen gerundet werden.")
    end
  end
  
  def self.latest
    Product.order(:updated_at).last
  end
end 
