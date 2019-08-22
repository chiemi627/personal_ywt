require 'csv'

class AdminController < ApplicationController
  def load
    if params[:retro_file] then
      CSV.foreach(params[:retro_file].path, headers: false) do |row|
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
      flash.now[:success] = "振り返りファイルをアップロードしました"
    end
  end
end
