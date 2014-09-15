class Judge
  include Mongoid::Document

  field :name
  field :level
  field :country, default: 'br'
  field :country_tree
  field :dci

  has_many :child_judges, :class_name => 'Judge', inverse_of: :parent_judge
  belongs_to :parent_judge, :class_name => 'Judge', inverse_of: :child_judges

  validates_presence_of :name, :level

  LEVEL_WORDS = {"1" => "one", "2" => "two", "3" => "three", "4" => "four", "5" => "five", "Inativo" => "inativo", "Emeritus" => "emeritus"}

  LEVEL_SHORT = {"1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5", "Inativo" => "IN", "Emeritus" => "E"}


  def self.levels
    ["1", "2", "3", "4", "5", I18n.t(:inactive), "Emeritus"]
  end

  def level_to_word
    LEVEL_WORDS[level]
  end

   def level_to_short
    LEVEL_SHORT[level]
  end

  def dci_number
    if dci.blank?
      0
    else
      dci
    end
  end


  def level_output
    if level == "Inativo"
      I18n.t("inactive")
    elseif level == "Emeritus"
      "Emeritus"
    else
      t(:level)+" level"
    end
  end

  def name_output
    name_parts = name.split(' ')
    if name_parts.count > 2
      "#{name_parts.first} #{name_parts.last}"
    else
      name
    end
  end

  def parent_name
    if(parent_judge)
      parent_judge.name
    end
  end

  def country_string
    IsoCountryCodes.find(country).name
  end

  def tree_string
    IsoCountryCodes.find(country_tree).name
  end

  def country_output
    unless country.downcase == "br"
      "<div class='flag flag-#{country.downcase}' title='#{IsoCountryCodes.find(country).name}'></div>"
    end
  end
end