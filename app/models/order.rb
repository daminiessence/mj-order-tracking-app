class Order < ApplicationRecord
  belongs_to :user, primary_key: :agent_id, foreign_key: :agent_id
  has_many :sales, primary_key: :no, foreign_key: :order_no
  validates :no, uniqueness: true
  accepts_nested_attributes_for :sales
end
