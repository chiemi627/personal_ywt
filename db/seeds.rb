# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Team.delete_all
Member.delete_all
Retrospective.delete_all

require "csv"

teams = {}

CSV.foreach('db/seeds/csv/teams.csv', headers: false) do |row|
    teams[row[0]] = Team.create(name:row[1])
end

CSV.foreach('db/seeds/csv/members.csv',headers: false) do |row|
    if teams[row[2]] then
        Member.create(account:row[0],name:row[1],team_id:teams[row[2]].id)
    end
end

CSV.foreach('db/seeds/csv/retrospectives.csv',headers: false) do |row|
    m = Member.find_by(account:row[0])
    if m then
        begin
            Retrospective.create(member_id:m.id,date:row[1],objective:row[2],y:row[3],w:row[4],t:row[5])        
        rescue => exception
            puts "#{row[0]}: the following error is found"
            puts exception        
        end
    else
        puts "#{row[0]} can not be found."
    end
end
