# frozen_string_literal: true

class Part < ActiveRecord::Base
  has_enumerated :fastener

  validates :fastener, presence: true
end
