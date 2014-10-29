require 'sinatra/base'
require 'sinatra/json'
require 'open-uri'

class Metlink < Sinatra::Application

  get '/' do
    'Metlink Api'
  end

  get '/stop/:number' do
    html = Nokogiri::HTML(
      open("http://www.metlink.org.nz/stop/#{params[:number]}/departures")
    )

    arrivals = []

    html.css('.data').each do |arrival_row|
      arrival = {}
      tds = arrival_row.xpath('td')
      arrival[:service] = tds[0].css('.id').first.content.strip
      arrival[:destination] = tds[1].css('span').first.content.strip
      arrival[:arrival_time] = tds[2].css('span').first.content.strip

      arrivals << arrival
    end

    json :arrivals => arrivals
  end

end


