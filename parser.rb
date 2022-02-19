
require 'nokogiri'
require 'httparty'
require 'pry'
require 'telegram/bot'

TOKEN = '5105333952:AAEkU-w1r3iNKpgH78qjuxF2Z0DQcqYf2A4'

def call
  adverts = Array.new

  a = adverts_listings3.css('p').text.chomp.delete("\n").split('.')
  adverts << a if a.size > 1

  adverts_listings2.each do |adverts_listing|
    advert = adverts_listing.css('p').text.chomp.delete("\n").split('#')
    advert.each do |i|
      advert.delete(i) if i.size < 5 || i.size > 30
    end
    adverts << advert
  end

  b = adverts_listings1.css('p').text.chomp.delete("\n").split('.')
  adverts << b if b.size > 1

  adverts_listings.each do |adverts_listing|
    advert = adverts_listing.css('p').text.chomp.delete("\n").split('***') # title
    advert.each do |i|
      advert.delete(i) if i.size < 5 || i.size > 30
    end
    adverts << advert
  end
  adverts
end

def parsed_page
  link = 'https://maximum.fm/citati-pro-lyubov-50-krilatih-fraz-i-visloviv-velikih-lyudej-pro-lyubov_n193027'
  Nokogiri::HTML(HTTParty.get(link).body)
end

def adverts_listings
  parsed_page.css('div.news-content.news-content-block')
end

def parsed_page1
  link = "https://citaty.net.ua/tsytaty-pro-kohannya-na-vidstani-200-tsytat/"
  Nokogiri::HTML(HTTParty.get(link).body)
end

def adverts_listings1
  parsed_page1.css('div.c')
end

def parsed_page2
  link = 'https://dd-restaurant.ru/uk/preserving-peppers/shekspir-krasivye-frazy-uilyam-shekspir-aforizmy-citaty-vyskazyvaniya/'
  Nokogiri::HTML(HTTParty.get(link).body)
end

def adverts_listings2
  parsed_page2.css('div.content')
end

def parsed_page3
  link = 'https://polychka.com/tsytaty-pro-kokhannia/'
  Nokogiri::HTML(HTTParty.get(link).body)
end

def adverts_listings3
  parsed_page3.css('div.entry-content.clearfix')
end

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::Message
      bot.api.send_message(chat_id: message.chat.id, text: call.sample.sample)
    end
  end
end


