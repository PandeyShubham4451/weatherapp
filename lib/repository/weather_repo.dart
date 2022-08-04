

import 'package:weatherapp/modal/search_city_modal.dart';
import 'package:weatherapp/modal/weather_detail_modal.dart';
import 'api_provider.dart';

class WeatherRepo {
  final _apiProvider = ApiProvider();

  Future<SearchCityModal> fetchCity(String city) async{
    var response = await _apiProvider.getRequest("http://52.73.146.184:3000/api/app/user/get-city-list?page=1&search=$city");
    return SearchCityModal.fromJson(response);
  }


  Future<WeatherDetailModal> fetchWeatherDetails(double? lat, double? long, String appId) async{
    var response = await _apiProvider.getRequest("https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&units=metric&appid=060395a4b021f72f641d9c415d72935d&exclude=current,minutely,hourly,alerts");
    return WeatherDetailModal.fromJson(response);
  }
}

