class Vote < ActiveRecord::Base
  attr_accessible :validity, :name, :status

  def self.import_errors
    where(:status => false).count
  end

end
