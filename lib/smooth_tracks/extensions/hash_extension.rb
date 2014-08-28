module HashExtension

  extend ActiveRecord::Concern

  def + other
    self.merge( other )
  end

end
