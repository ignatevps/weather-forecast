require 'date'

class MeteoForecast
  TIME_OF_DAY = %w[night morning afternoon evening].freeze
  CLOUDINESS = %w[clear partly_cloudy cloudy overcast].freeze

  def initialize(params)
    @date = params[:date]
    @time_of_day = params[:time_of_day]
    @temperature_min = params[:temperature_min]
    @temperature_max = params[:temperature_max]
    @cloudiness = params[:cloudiness]
    @max_wind = params[:max_wind]
  end

  def self.from_xml(node)
    day = node.attributes['day']
    month = node.attributes['month']
    year = node.attributes['year']

    new(
      date: Date.parse("#{day}.#{month}.#{year}"),
      time_of_day: TIME_OF_DAY[node.attributes['tod'].to_i],
      temperature_max: node.elements['TEMPERATURE'].attributes['max'].to_i,
      temperature_min: node.elements['TEMPERATURE'].attributes['min'].to_i,
      cloudiness: CLOUDINESS[node.elements['PHENOMENA'].attributes['cloudiness'].to_i],
      max_wind: node.elements['WIND'].attributes['max'].to_i
    )
  end

  def to_s
    result = today? ? 'Сегодня' : @date.strftime('%d.%m.%Y')

    result << ", #{@time_of_day}\n" \
      "#{temperature_range_string}, wind #{@max_wind} m/s, #{@cloudiness}"

    result
  end

  def temperature_range_string
    result = ''
    result << '+' if @temperature_min.positive?
    result << "#{@temperature_min}.."
    result << '+' if @temperature_max.positive?
    result << @temperature_max.to_s
    result
  end

  def today?
    @date == Date.today
  end
end
