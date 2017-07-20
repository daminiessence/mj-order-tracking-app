class Sale < ApplicationRecord
  belongs_to :order, primary_key: :no, foreign_key: :order_no
  belongs_to :product, primary_key: :sid, foreign_key: :product_sid
end
