require '../lib/meteo_forecast'

describe MeteoForecast do
  context '#to_s' do
    let(:forecast) do
      MeteoForecast.new(
        date: Date.parse('30.03.2023'),
        time_of_day: 'morning',
        temperature_min: 10,
        temperature_max: 13,
        cloudiness: 'clear',
        max_wind: 10
      )
    end

    it 'displays temperature range' do
      expect(forecast.to_s).to include('+10..+13')
    end

    it 'displays date' do
      expect(forecast.to_s).to include('30.03.2023')
    end

    it 'displays cloudiness' do
      expect(forecast.to_s).to include('clear')
    end

    it 'displays wind speed' do
      expect(forecast.to_s).to include('wind 10 m/s')
    end
  end
end
