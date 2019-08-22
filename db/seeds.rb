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

#siscorn = Team.create(name: "シスコーン")
#suda = Member.create(account:"201711373", name:"須田　幹大",team_id:siscorn.id)

#Retrospective.create(date:"2018-07-31", member_id:suda.id, objective:"チームのメンバーと意識して会話する",y:"スクラムマスターとして時間管理はするように意識した。 (自分も含めて)チームのメンバーに自分の作業が得意なタイプが多かったので、意識して会話数を増やすようにした。 タスク分割の際には自分の技術力をチーム全体に還元できるよう、メンバーの理解が追いついているかを確認することを意識した",w:"メンバーの一人に以外なリーダーシップ性があることに気づいたのは良い収穫だったと思う。 バックボードやタスク分割もかなりスムーズに行ったが、これはチーム全体として今やっていることを把握できたためだと思うので、明日以降も「今何をやっているのか」をチーム全体で共有できるように意識したい。",t:"明日は自分たちで時間管理をする必要があるので、スマートフォンのタイマーを上手く活用していきたい。")

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
