# coding: utf-8
namespace :database do
  desc "Add Participants to Database"
  task :populate => :environment do
    i = 4691
    while i < 6447 do
      part = Participant.new
      part.age = 1
      part.uid = i
      part.save
      i += 15
    end
  end
end