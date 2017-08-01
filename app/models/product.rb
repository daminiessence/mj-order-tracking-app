class Product < ApplicationRecord

  has_many :sales, primary_key: :sid, foreign_key: :product_sid, inverse_of: :product

  validates :sid,
    presence: true,
    format: { with: /\A([\w\d]|[-_.])+\z/ },
    uniqueness: true
  validates :name,
    presence: true,
    format: { with: /\A(\S(\S|\s)*\S|\S)\z/ },
    length: { minimum: 1 }
  validates :suggested_price,
    numericality: { greater_than_or_equal_to: 0.0 }

  def formatted_suggested_price
    'RM %.2f' % [ suggested_price ]
  end

end
