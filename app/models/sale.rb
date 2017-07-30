class Sale < ApplicationRecord

  VALID_AMOUNT_REGEX = /\A[1-9][0-9]*\z/
  VALID_SALE_PRICE_REGEX = /\A(0|[1-9][0-9]*)\.[0-9]{1,2}\z/

  belongs_to :order,
    primary_key: :no, foreign_key: :order_no,
    inverse_of: :sales
  belongs_to :product,
    primary_key: :sid, foreign_key: :product_sid,
    inverse_of: :sales

  validates :sale_price,
    presence: true,
    format: { with: VALID_SALE_PRICE_REGEX },
    numericality: { greater_than_or_equal_to: 0.00 }
  validates :amount,
    presence: true,
    format: { with: VALID_AMOUNT_REGEX },
    numericality: { only_integer: true }

end
