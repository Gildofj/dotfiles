import type { WeatherOutput } from "zebar";
import { useZebar } from "../context/OutputContext";

export function Weather() {
  const output = useZebar();

  function getWeatherIcon(weatherOutput: WeatherOutput) {
    switch (weatherOutput.status) {
      case "clear_day":
        return <i class="nf nf-weather-day_sunny"></i>;
      case "clear_night":
        return <i class="nf nf-weather-night_clear"></i>;
      case "cloudy_day":
        return <i class="nf nf-weather-day_cloudy"></i>;
      case "cloudy_night":
        return <i class="nf nf-weather-night_alt_cloudy"></i>;
      case "light_rain_day":
        return <i class="nf nf-weather-day_sprinkle"></i>;
      case "light_rain_night":
        return <i class="nf nf-weather-night_alt_sprinkle"></i>;
      case "heavy_rain_day":
        return <i class="nf nf-weather-day_rain"></i>;
      case "heavy_rain_night":
        return <i class="nf nf-weather-night_alt_rain"></i>;
      case "snow_day":
        return <i class="nf nf-weather-day_snow"></i>;
      case "snow_night":
        return <i class="nf nf-weather-night_alt_snow"></i>;
      case "thunder_day":
        return <i class="nf nf-weather-day_lightning"></i>;
      case "thunder_night":
        return <i class="nf nf-weather-night_alt_lightning"></i>;
    }
  }

  return (
    output.weather && (
      <div class="weather">
        {getWeatherIcon(output.weather)}
        {Math.round(output.weather.celsiusTemp)}°C
      </div>
    )
  );
}
