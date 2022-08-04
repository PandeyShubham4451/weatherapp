import 'dart:async';
import 'dart:convert';

import 'package:weatherapp/modal/search_city_modal.dart';
import 'package:weatherapp/modal/weather_detail_modal.dart';
import 'package:weatherapp/repository/weather_repo.dart';
import '../repository/response.dart';

class WeatherBloc {

  String appId = "060395a4b021f72f641d9c415d72935d";


   late WeatherRepo weatherRepo;
   late var _searchCityController = StreamController<Response<SearchCityModal>>();
   late var _fetchWeatherDetail = StreamController<Response<WeatherDetailModal>>();


   WeatherBloc(){
     weatherRepo = WeatherRepo();
     _searchCityController = StreamController<Response<SearchCityModal>>.broadcast();
     _fetchWeatherDetail = StreamController<Response<WeatherDetailModal>>.broadcast();
   }


   Stream<Response<SearchCityModal>> get searchCityStream => _searchCityController.stream;
   StreamSink<Response<SearchCityModal>> get searchCitySink => _searchCityController.sink;

   Stream<Response<WeatherDetailModal>> get fetchWeatherStream => _fetchWeatherDetail.stream;
   StreamSink<Response<WeatherDetailModal>> get fetchWeatherSink => _fetchWeatherDetail.sink;
   
   
   dispose() {
     _searchCityController.close();
     _fetchWeatherDetail.close();
   }

   getCities(String city) async{
     searchCitySink.add(Response.loading("Loading..."));
     try {
       SearchCityModal res = await weatherRepo.fetchCity(city);

       if (res.status != 200) {
         searchCitySink.add(Response.error("Error Occurs"));
       } else {
         searchCitySink.add(Response.completed(res));
       }
     } catch (e) {
       searchCitySink.add(Response.error("Something went wrong"));
     }
   }

   getWeatherDetails(double? lat, double? long) async{
     fetchWeatherSink.add(Response.loading("Loading..."));
     try {
       WeatherDetailModal res = await weatherRepo.fetchWeatherDetails(lat, long, appId);
       print("Data $res");
       if (res.daily == []) {
         fetchWeatherSink.add(Response.error("Error Occurs"));
       } else {
         fetchWeatherSink.add(Response.completed(res));
       }
     } catch (e) {
       print("Exception $e");
       fetchWeatherSink.add(Response.error("Something went wrong"));
     }
   }
}