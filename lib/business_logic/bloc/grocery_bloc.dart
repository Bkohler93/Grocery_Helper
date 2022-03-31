/*
 * EXAMPLE BLOC:
 *
 * class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
 *  final WeatherRepository repisotory
 * 
 *  Stream mapEventToState(event) async* {
 *    if (event is GetWeatherEvent) {
 *      yield WeatherLoading();
 *      try {
 *        final Weather weather = await repository.getWeather(event.cityName);
 *        yield WeatherLoaded(weather);
 *      }catch(error) {
 *        yield Failure(error);
 *      } 
 *    }
 *   }
 * }
 *  
*/