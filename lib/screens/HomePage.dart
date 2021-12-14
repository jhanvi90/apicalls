import 'dart:convert';

import 'package:apicalls/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:apicalls/model/passenger_data.dart';
import 'package:http/http.dart' as http;

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:connectivity_widget/connectivity_widget.dart';

class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;

  DatabaseHelper helper=DatabaseHelper();
   int totalPages;
  List<Passenger> passengers = [];
  List<Passenger> LocalData = [];

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  // Future getd() async
  // {
  //   final Uri uri = Uri.parse("https://api.github.com/users/JakeWharton/repos?page=10&per_page=15");
  //   print(uri);
  //   final response = await http.get(uri);
  //   List re=json.decode(response.body);
  //   print(json.decode(response.body));
  //   print(re.isEmpty);
  // }

  Future<bool> getPassengerData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
    }

    final Uri uri = Uri.parse("https://api.instantwebtools.net/v1/passenger?page=1913&size=10");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final result = passengersDataFromJson(response.body);
      print(result.data.isEmpty);

      if (isRefresh) {
        passengers = result.data;
      }else{
        if(result.data.isEmpty)
          {
            return false;
          }
        else{
          if(result.data.isEmpty)
            {
              return false;
            }
          else{
            passengers.addAll(result.data);
          }

        }

      }

      currentPage++;

      totalPages = result.totalPages;
      for(var i=0;i<passengers.length;i++)
        {
         helper.insertPassenger(passengers[i]).whenComplete((){
           Future<List<Passenger>> ProductListFuture = helper.getPassengerList();
           ProductListFuture.then((ProductList) {
             setState(() {
               this.LocalData=ProductList;
             });

           });
         });
        }
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future<List<Passenger>> ProductListFuture = helper.getPassengerList();
    ProductListFuture.then((ProductList) {
      setState(() {
        this.LocalData=ProductList;
      });

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("Data List With Pagination",style: TextStyle(color: Colors.white),),
      ),
      body:
          ConnectivityWidget(
              builder: (context,isOnline){
                return isOnline?
                SmartRefresher(
                  controller: refreshController,
                  enablePullUp: true,
                  onRefresh: () async {
                    final result = await getPassengerData(isRefresh: true);
                    if (result) {
                      refreshController.refreshCompleted();
                    } else {
                      refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async {
                    final result = await getPassengerData();
                    print(result);
                    if (result) {
                      refreshController.loadComplete();
                    } else {
                      refreshController.loadFailed();

                    }
                  },
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final passenger = passengers[index];
                      return ListTile(
                        title: Text("Passenger Name : ${passenger.name}"),
                        subtitle: Text("No of Trips : ${passenger.trips}"),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: passengers.length,
                  ),
                ):
                ListView.separated(
                  itemBuilder: (context, index)
                  {
                    return ListTile(
                      title: Text("Passenger Name : ${LocalData[index].name}"),
                      subtitle: Text("No of Trips : ${LocalData[index].trips}"),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: LocalData.length,
                );
              }
          ),


    );
  }
}
