class Importer

  class VoteInvalid     < StandardError; end
  class TimeInvalid     < StandardError; end
  class CampaignInvalid < StandardError; end
  class ValidityInvalid < StandardError; end
  class ChoiceInvalid   < StandardError; end

  def initialize(link)
    @file = File.open(link, "r")
  end


  def get
    @file.each_line do |ln|
      ln = ln.encode('UTF-8', 'binary', :undef => :replace, :invalid => :replace).split(" ")
      begin

        h = ln[2..-1].inject({}) {|h, e| k, v = e.split(':') ; h[k.downcase.to_sym] = v; h}.merge(:status => true)

        raise VoteInvalid.new("Vote not in right place")         if vote_invalid?(ln)
        raise TimeInvalid.new("Time invalid")                    if time_invalid?(ln)
        raise CampaignInvalid.new("Campaign not in right place") if campaign_invalid?(ln)
        raise ValidityInvalid.new("Validity not in right place") if validity_invalid?(ln)
        raise ChoiceInvalid.new("Choice empty")                  if choice_invalid?(ln)
        campaign = Campaign.find_or_create_by_name(:name => h[:campaign])

      rescue Exception => e
        Vote.create(:validity => h[:validity], :name => h[:choice], :status => false)
        next
      end
      campaign.votes.create(:validity => h[:validity], :name => h[:choice], :status => h[:status])

    end
  end

  private

  def vote_invalid?(ln)
    ln[0] != "VOTE"
  end

  def time_invalid?(ln)
    ln[1].size != 10
  end

  def campaign_invalid?(ln)
    ln[2].split(":")[0] != "Campaign"
  end

  def validity_invalid?(ln)
    val = ln[3].split(":")
    val[0] != "Validity" && ["during", "pos", "pre"].include?(val[1])
  end

  def choice_invalid?(ln)
    ln[4].split(":")[1].size < 3
  end

end

##################################################################
# This solution have few main problems:
# 1. with this how it works it's near impossible to figure out
#   what was wrong, script should first create vote with strig
#   straignt from read file line and later link it if it's possible
#   in this case it would be easy to figure out what was wrong 
#   and we have 100% guaranee that all votes are in db
# 2. another problem is that it's impossible with this structure
#    to keep votes without campaign, it's possible but it's done
#    just to have it 
# 3. indexes are missing right now it's super slow
#   at last it's not taking all txt file to memory only it's reading
#   by lines
# 4. arel queries can be done with scope and with chaining with this
#  it would be easier to sort scores;
# 5. to much array/string operations in import this should be in model
#  when strip will link votes to campaigns and candidates
# 6. line nr 19 is too complex but this becasuse I did not
#  read enought carefull this line "All well-formed lines will have 
#  the same fields, in the same order."
# 7. script should be executable and take as first param link to file
# 8. I can't look more on this, so I'm sending it :)
##################################################################





