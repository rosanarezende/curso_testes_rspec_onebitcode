class User < ApplicationRecord
  enum kind: [ :knight, :wizard ]
  # validações
  validates :level, numericality: { greater_than: 0, less_than_or_equal_to: 99 }

  # método customizado
  def title
    "#{self.kind} #{self.nickname} ##{self.level}"
  end
end
