# frozen_string_literal: true

# data from https://legacy.meteoservice.ru

# библиотека которая отправляет запросы на сайты
require 'net/http'
require 'rexml/document'

require_relative 'lib/meteo_forecast'

CITIES = {
  37 => 'Москва',
  69 => 'Санкт-Петербург',
  99 => 'Новосибирск',
  59 => 'Пермь',
  115 => 'Орел',
  121 => 'Чита',
  141 => 'Братск',
  137 => 'Петрозаводск'
}.invert.freeze

# Сделаем массив из наваний городов, взяв ключи массива CITIES
city_names = CITIES.keys

# Спрашиваем у пользователя, какой город по порядку ему нужен
puts 'Погоду для какого города Вы хотите узнать?'
city_names.each_with_index { |name, index| puts "#{index + 1}: #{name}" }
city_index = gets.to_i
unless city_index.between?(1, city_names.size)
  city_index = gets.to_i
  puts "Введите число от 1 до #{city_names.size}"
end

# Когда, наконец, получим нужый индекс, достаем city_id
city_id = CITIES[city_names[city_index - 1]]

CLOUDINESS = %w[Ясно Малооблачно Облачно Пасмурно].freeze

uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{city_id}.xml")

response = Net::HTTP.get_response(uri)

doc = REXML::Document.new(response.body)

city_name = URI.decode_www_form(doc.root.elements['REPORT/TOWN'].attributes['sname'])

forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a

puts city_name
puts

forecast_nodes.each do |node|
  puts MeteoForecast.from_xml(node)
  puts
end
