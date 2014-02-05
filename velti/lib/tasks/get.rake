namespace :get do
  desc "Get votes from file in doc, and feed db"
  task :votes => :environment do

      Importer.new("doc/votes.txt").get

  end

end
