import 'package:flutter/material.dart';
import 'package:weatherapp/modal/search_city_modal.dart';
import 'package:weatherapp/repository/response.dart';
import 'package:weatherapp/screens/weather_detail.dart';

import '../bloc/weather_bloc.dart';
class CityList extends StatefulWidget {

  @override
  _CityListState createState() => _CityListState();
}


class _CityListState extends State<CityList> {
  late WeatherBloc _weatherBloc;

  TextEditingController citySearchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _weatherBloc = WeatherBloc();
    _weatherBloc.getCities("");

    _weatherBloc.searchCityStream.listen((event) {
      switch (event.status) {
        case Status.LOADING:
          break;
        case Status.COMPLETED:
          break;
        case Status.ERROR:
          // TODO: Handle this case.
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text(
                    "Change City",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(top: 5),
                  child: TextField(
                    controller: citySearchController,
                    onChanged: (String value) {
                      if (value.length >= 3) {
                        _weatherBloc.getCities(value);
                      }
                      if (value.isEmpty) {
                        _weatherBloc.getCities("");
                      }
                      setState(() {});
                    },
                    style: const TextStyle(fontSize: 19),
                    decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.only(top: 20, left: 15, bottom: 20),
                        hintText: "Enter City Name",
                        hintStyle: const TextStyle(fontSize: 19),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey,width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey,width: 1),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                citySearchController.text.length >= 3
                    ? Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 10),
                  child: StreamBuilder<Response<SearchCityModal>>(
                    stream: _weatherBloc.searchCityStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data?.status) {
                          case Status.LOADING:
                            return Container(
                              alignment: Alignment.center,
                              child: const Text("Loading"),
                            );
                            break;

                          case Status.COMPLETED:
                            return ListView.builder(
                                shrinkWrap: true,
                                // separatorBuilder: (context, i)=>const Divider(indent: 10,
                                //   color: Colors.black54,
                                //   thickness: 1,),
                                physics:
                                const NeverScrollableScrollPhysics(),
                                itemCount: snapshot
                                    .data?.data?.data?.record?.length,
                                itemBuilder: (context, i) {
                                  var data = snapshot
                                      .data?.data?.data?.record![i];
                                  return GestureDetector(
                                    child: Container(
                                        margin:
                                        const EdgeInsets.all(10),
                                        padding: const EdgeInsets.only(
                                            top: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              "${data?.name}",
                                              style: const TextStyle(
                                                  fontSize:
                                                  20,
                                                  fontWeight:
                                                  FontWeight
                                                      .w400,
                                                  color: Colors
                                                      .black),
                                            ),
                                            const SizedBox(height: 5,),
                                            Text(
                                                "${data?.country}",
                                                textAlign:
                                                TextAlign
                                                    .center,
                                                style: const TextStyle(
                                                    fontSize:12,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    color: Colors
                                                        .black)),
                                            const SizedBox(height: 5,),
                                            const Divider(height: 1,thickness: 1,color: Colors.grey,)

                                          ],
                                        )),
                                    onTap: () async {
                                      Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(builder: (context) =>  WeatherDetail(
                                            city: data?.name,
                                            lat: data?.coord?.lat,
                                            lang: data?.coord?.lon,
                                          )),
                                              (Route<dynamic> route) => false);
                                    },
                                  );
                                });

                            break;

                          case Status.ERROR:
                            return Container(
                                alignment: Alignment.center,
                                child: const Text(""));

                            break;
                          default:
                        }
                      }
                      return Container();
                    },
                  ),
                )
                    : Container(),
              ],
            ),
          ),
        ));
  }
}
