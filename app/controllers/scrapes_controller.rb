 require 'nokogiri'
class ScrapesController < ApplicationController
  def index
    doc = Nokogiri::HTML(open('http://colleges.usnews.rankingsandreviews.com/best-colleges/rankings/national-universities/data'))
    table_thead=""
    doc.xpath("//*[@id='article']/table/thead").each do |link|
       table_thead=link.content
     end  

     final_output = []
     #get all the the rows from table head
     rows = doc.css("tr[valign='top']")
      get_header_from_table = get_reject_data(table_thead.split(/\W\n/))
      rows.each do |row|

      get_value =  get_proper_text(row.text)
      p get_value
      final_output  << Hash[get_header_from_table.zip get_value ]
       end
    # render json: final_output
   @scrapes = final_output
  end

 # remove unwanted space black comment from raw data
  def get_reject_data (raw_data)
   raw_data.reject { |u| u=="       " || u=="\n       " || u == "         " || u == "          " || u == ""}.map {|u| u.strip.downcase.split(' ').join('_')}.reject{ |u| u== ""}
  end 

# remove unwanted space black comment from raw data
  def get_proper_text(raw_text)
   raw_text.split(/\W\n/).reject { |u| u=="       " || u=="\n       " || u == "         " || u == "          " || u == ""}.map {|u| u.strip}.reject{ |u| u== "" || u== "Locked"} # Will print all the 'this is a line'
  end
end
