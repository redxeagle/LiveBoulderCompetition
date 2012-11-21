namespace :database do
  desc "Add Reservations to Database"
  task :reservations => :environment do
    #reservation_file= File.open("#{Rails.root}/db/data/reservations.yml")

    reservations = YAML::load_file("#{Rails.root}/db/data/reservations.yml")
    reserv = Participant.all
    reserv.each do |r|
      r.delete
    end
    i = 1001
     reservations.fetch("reservations").fetch("records").each do |participant|
       new_participant = Participant.new
       new_participant.name = participant[1]
       new_participant.given_name = participant[2]
       new_participant.gender = participant[4]
       new_participant.location = participant[3]
       new_participant.age = participant[7]
       new_participant.power = participant[8]
       new_participant.uid = i
       new_participant.save
       i = i + 15
     end
  end
end