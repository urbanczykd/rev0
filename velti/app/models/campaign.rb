class Campaign < ActiveRecord::Base
  attr_accessible :name
  has_many :votes

  def overal_errors
    votes.where(:status => false).count
  end

  def all_votes(name)
    votes.where(:name => name).count
  end

  def candidates
    votes.select("DISTINCT(NAME)")
  end

  def valid_errors(name)
    votes.where(:name => name, :status => false).count
  end

  def valid_votes(name)
    votes.where(:name => name, :validity => "during", :status => true).count
  end

  def invalid(name)
    votes.where(:name => name).where(['name = ? AND validity = ? OR validity = ?', name, 'pre', 'post']).count
  end


end
