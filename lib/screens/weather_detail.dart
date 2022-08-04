import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/modal/weather_detail_modal.dart';
import 'package:weatherapp/repository/response.dart';
import 'package:weatherapp/screens/city_list.dart';
import '../bloc/weather_bloc.dart';
class WeatherDetail extends StatefulWidget {
  final String? city;
  final double? lat;
  final double? lang;
  const WeatherDetail({ required this.city,
    required this.lat, required this.lang,
    Key? key}) : super(key: key);

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> {
  DateTime selectedDate = DateTime.now();
  late WeatherBloc _weatherBloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _weatherBloc = WeatherBloc();
    _weatherBloc.getWeatherDetails(widget.lat,widget.lang);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: StreamBuilder<Response<WeatherDetailModal>>(
              stream: _weatherBloc.fetchWeatherStream,
              builder: (BuildContext context, AsyncSnapshot<Response<WeatherDetailModal>> snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data?.status) {
                    case Status.LOADING:
                      return Container(
                        alignment: Alignment.center,
                        child: const Text("Loading"),
                      );
                      break;
                    case Status.COMPLETED:
                      var data = snapshot
                          .data?.data?.daily?.length;
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration:  const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.green,
                                Colors.greenAccent,
                              ],
                            )
                        ),

                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Current Weather",style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18
                                    ),),
                                    GestureDetector(
                                      child: Row(
                                        children:  [
                                          SizedBox(
                                            width:80,
                                            child: Text("${widget.city}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontSize: 14
                                                )),),
                                          const Icon(Icons.keyboard_arrow_down,color: Colors.white,)
                                        ],
                                      ),
                                      onTap: (){
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => CityList()));
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                     Text("${snapshot
                                         .data?.data?.daily![0]?.temp?.day}\u00B0",style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),),
                                    Column(
                                      children:  [
                                        snapshot
                                            .data?.data?.daily![0].weather![0].main =="Rain"
                                            ?Icon(Icons.grain,color: Colors.white,)
                                            :snapshot
                                            .data?.data?.daily![0].weather![0].main =="Clear"
                                            ?Icon(Icons.wb_sunny,color: Colors.white,)
                                            :Icon(Icons.cloud_queue_rounded,color: Colors.white,),
                                        Text("${snapshot
                                            .data?.data?.daily![0].weather![0].main}",style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18
                                        ),),
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(DateFormat.d().
                                            format(DateTime.parse(selectedDate.toString())),style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15
                                            ),),
                                            const SizedBox(width: 10,),
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundColor: Colors.lightBlue.shade100,
                                              child: const Icon(Icons.calendar_today,
                                                color: Colors.lightBlue,
                                                size: 15,),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 3,),
                                        Text(DateFormat('EEE, yyyy').
                                        format(DateTime.parse(selectedDate.toString())),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10
                                          ),),

                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    _selectDate(context);
                                  },
                                )
                              ],
                            ),
                            const SizedBox(height: 15,),
                            SizedBox(
                              height: 60,
                                child:
                            ListView.builder(
                                itemCount: data,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context , i){
                                  var x = snapshot
                                      .data?.data?.daily![i];
                                  return Row(
                                    children: [
                                      Column(
                                        children:  [
                                          x?.weather![0].main =="Rain"
                                          ?Icon(Icons.grain,color: Colors.white,)
                                          :x?.weather![0].main =="Clear"
                                              ?Icon(Icons.wb_sunny,color: Colors.white,)
                                          :Icon(Icons.cloud_queue_rounded,color: Colors.white,),
                                          Text("${x?.weather![0].main}",style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15
                                          ),),
                                          Text("${x?.temp?.day}\u00B0",style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10
                                          ),),
                                        ],
                                      ),
                                      const  SizedBox(width: 10,),

                                    ],
                                  );
                                })
                            )
                          ],
                        ),
                      );
                      break;
                    case Status.ERROR:
                      return Container(
                          alignment: Alignment.center,
                          child: const Text("Error Showing"));
                      break;
                    default:
                  }
                }
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration:  const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green,
                          Colors.greenAccent,
                        ],
                      )
                  ),

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Current Weather",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                              ),),
                              GestureDetector(
                                child: Row(
                                  children:  [
                                    SizedBox(
                                      width:80,
                                      child: Text("${widget.city}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14
                                          )),),
                                    const Icon(Icons.keyboard_arrow_down,color: Colors.white,)
                                  ],
                                ),
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => CityList()));
                                },
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Text("16\u00B0",style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22
                              ),),
                              Column(
                                children: const [
                                  Icon(Icons.wb_sunny,color: Colors.white,),
                                  Text("Sunny",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                  ),),
                                ],
                              )
                            ],
                          ),
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(DateFormat.d().
                                      format(DateTime.parse(selectedDate.toString())),style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                      ),),
                                      const SizedBox(width: 10,),
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.lightBlue.shade100,
                                        child: const Icon(Icons.calendar_today,
                                          color: Colors.lightBlue,
                                          size: 15,),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 3,),
                                  Text(DateFormat('EEE, yyyy').
                                  format(DateTime.parse(selectedDate.toString())),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10
                                    ),),

                                ],
                              ),
                            ),
                            onTap: (){
                              _selectDate(context);
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          Column(
                            children: const [
                              Icon(Icons.cloud_queue_rounded,color: Colors.white,),
                              Text("Cloudy",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),),
                            ],
                          ),
                          const  SizedBox(width: 10,),
                          Column(
                            children: const [
                              Icon(Icons.wb_sunny,color: Colors.white,),
                              Text("Sunny",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),),
                            ],
                          ),
                          const  SizedBox(width: 10,),
                          Column(
                            children: const [
                              Icon(Icons.wb_sunny,color: Colors.white,),
                              Text("Sunny",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),),
                            ],
                          ),
                          const  SizedBox(width: 10,),
                          Column(
                            children: const [
                              Icon(Icons.wb_sunny,color: Colors.white,),
                              Text("Sunny",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),),
                            ],
                          ),
                          const  SizedBox(width: 10,),
                          Column(
                            children: const [
                              Icon(Icons.wb_sunny,color: Colors.white,),
                              Text("Sunny",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
        ),
      )
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale('en', 'IN'),
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print("selectDate $selectedDate");
      });
    }
  }
}
