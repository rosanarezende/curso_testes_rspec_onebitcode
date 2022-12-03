# - criar model
# rails generate model weapon

# - adicionar campos no model
# rails g migration add_name_description_level_powerbase_powerstep_to_weapon 
# name:string description:text power_base:integer power_step:integer level:integer

class Weapon < ApplicationRecord
  # ==== validações ====
  # level: começa em 1 e não tem restrição de máximo
  validates :level, numericality: { greater_than: 0, less_than_or_equal_to: 99 }

  # minha ideia - não pode deixar o usuário criar uma arma sem nome e sem descrição
  validates :name, :description, presence: true

  # power_base: começa em 3000
  validates :power_base, inclusion: { in: [3000, 6000, 9000] }

  # power_step: + 100 por level
  validates :power_step, numericality: { equal_to:100 }

  # ==== métodos ====
  # método que demonstra o poder atual da arma
  def current_power
    self.power_base + (self.power_step * (self.level - 1))
  end

  # método que mostra o título da arma
  def title
    "#{self.name} ##{self.level}"
  end
end
