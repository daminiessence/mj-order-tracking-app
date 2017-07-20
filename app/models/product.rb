class Product < ApplicationRecord
  has_many :sales, primary_key: :sid, foreign_key: :product_sid
end
