import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weatherappsample/constants.dart' as k;

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

 class _WeatherAppState extends State<WeatherApp> {
  bool isLoaded=false;
  num? temp;
  num? pressure;
  num? humidity;
  num? sunrise;
  num? sea_level;
  String city_name='';

  // final now = new DateTime.now();
  // String formatter = DateFormat('yMd').format(now);



  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
getCurrentLocation();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child:Column(
                children: [
                  Container(

          height: MediaQuery.of(context).size.height/1,
          width: MediaQuery.of(context).size.width/1,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(("images/weather.jpeg")),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child:
                   
                 Text(city_name,style: TextStyle(fontSize: 60,
                     fontWeight: FontWeight.bold,
                     color: Colors.white),
                 ),
               ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(now,style: TextStyle(fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Pressure:${pressure?.toInt()}',style: TextStyle(fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Humidity:${humidity?.toInt()}',style: TextStyle(fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Sunrise:${sunrise?.round()}',style: TextStyle(fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                ),
              ),
            SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,),
                child: Icon(Icons.cloud,size: 60,color: Colors.white.withOpacity(0.6)),
              ),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('${temp?.toInt()}°c',style: TextStyle(fontSize: 90,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.5)),
                ),
              ),

            ],
          ),

                  ),
                ],
              ),
        ),

      ),
    );
  }
  getCurrentLocation()async{
    var position=await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
    );
    if(position!=null){
      print('lat:${position.latitude},long:${position.longitude}');
      getCurrentCityWeather(position);
    }
    else{
      print("Data Unavailable");
    }
  }
  getCurrentCityWeather(Position pos) async{
    var client=http.Client();
    var uri='${k.domain}lat=${pos.latitude}&lon=${pos.longitude}&appid=${k.apiKey}';
    var url=Uri.parse(uri);
    var response=await client.get(url);
    if(response.statusCode==200){
      var data=response.body;
      var decodeData=jsonDecode(data);
      print(data);
      UpdateUi(decodeData);
      setState(() {
        isLoaded=true;
      });

    }
  }
  UpdateUi(var decodeData){
    setState(() {
      if(decodeData==null){
      temp = 0;
      pressure = 0;
      humidity = 0;
      sea_level = 0;
      sunrise=0;
      city_name = "Not Available";
    }
    else{
        temp=decodeData['main']['temp']-273;
        pressure=decodeData['main']['pressure'];
        humidity=decodeData['main']['humidity'];
        sea_level=decodeData['main']['sea_level'];
        sunrise=decodeData['sys']['sunrise'];

        print("temp${temp}");
        print("p${pressure}");
        print("hu${humidity}");
        }
    });
  }
  getCityWeather(String cityname)async{
    var client=http.Client();
    var uri='${k.domain}q=$cityname&appid=${k.apiKey}';
    var url=Uri.parse(uri);
    var response=await client.get(url);
    if(response.statusCode==200){
      var data=response.body;
      var decodeData=jsonDecode(data);
    print(data);
   UpdateUi(decodeData);
   setState(() {
     isLoaded=true;
   });
    }
    else{
      print(response.statusCode);
    }
  }
}


