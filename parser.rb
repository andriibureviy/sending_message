require 'nokogiri'
require 'httparty'
require 'pry'
require 'telegram/bot'

TOKEN = '5105333952:AAEkU-w1r3iNKpgH78qjuxF2Z0DQcqYf2A4'

def call
  parsed_page
  adverts = Array.new
  adverts_listings.each do |adverts_listing|
    advert = adverts_listing.css('p').text.chomp.delete("\n").split('***') # title
    advert.each do |i|
      advert.delete(i) if i.size < 5 || i.size > 30
    end
    adverts << advert
  end
  p adverts
end

def url
  'https://maximum.fm/citati-pro-lyubov-50-krilatih-fraz-i-visloviv-velikih-lyudej-pro-lyubov_n193027'
end


def unparsed_page
  HTTParty.get(url)
end

def parsed_page
  Nokogiri::HTML(unparsed_page.body)
end

def adverts_listings
  parsed_page.css('div.news-content.news-content-block')
end

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    when '/love'
      bot.api.send_message(chat_id: message.chat.id,
                           text: call.sample.sample)
    end
  end
end

