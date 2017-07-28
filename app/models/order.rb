class Order < ApplicationRecord

  NO_REGEX = /\A(0|[1-9][0-9]*)\z/

  belongs_to :user, primary_key: :agent_id, foreign_key: :agent_id
  has_many :sales, primary_key: :no, foreign_key: :order_no

  validates :no,
    presence: true,
    uniqueness: true,
    format: { with: NO_REGEX }

  accepts_nested_attributes_for :sales
end
