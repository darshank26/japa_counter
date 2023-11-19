
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:japa_counter/screens/addCounter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AdHelper/adshelper.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedValue = -1; // Initial value for the selected radio button
  var cN;
  var cV;
  late SharedPreferences prefs;
   late SharedPreferences result;
   var _countComplete = 0;
   var _totalCount = 0;

  StreamSubscription<HardwareButton>? subscription;

  late BannerAd _bannerAd;

  bool _isBannerAdReady = false;


  void startListening() {


    subscription = FlutterAndroidVolumeKeydown.stream.listen((event) {

      if (event == HardwareButton.volume_down) {

        setState(() {
          if (_totalCount > 0) {
            _totalCount--;


            if (_totalCount % int.parse(result.getString('CounterValue').toString()) == 0) {
              if (_countComplete != 0) {
                _countComplete--;
              }
            }
        }});



          print("Volume down received");
        } else if (event == HardwareButton.volume_up) {

        setState(() {
          _totalCount++;

          if (_totalCount %
              int.parse(result.getString('CounterValue').toString()) == 0) {
            _countComplete++;
          }
        });


          print("Volume up received");
        }

    });
  }

  void stopListening() {
    subscription?.cancel();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      _loadLastSelectedValue();
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitIdOfHomeScreen,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();

  }

  _loadLastSelectedValue() async {
     prefs = await SharedPreferences.getInstance();
     result = await SharedPreferences.getInstance();

     setState(() {
      selectedValue = prefs.getInt('selectedValue') ?? -1;
       cN = prefs.getString('CounterName');
       cV = prefs.getString('CounterValue');

      print("--"+selectedValue.toString());
      print("--"+cN.toString());
      print("--"+cV.toString());

    });
  }


  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Japa Counter",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,letterSpacing: 0.5),),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,

        actions: [


          GestureDetector(
            onTap: () async{
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCounter()));

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCounter())).then((value) {
                setState(() {

                });
              });
              var box  = await Hive.openBox('HiveDB');

            },
            child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text("Add Counter",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,letterSpacing: 0.5)),
                SizedBox(width: 5,),
                Icon(Icons.add_box_outlined,size: 28,color: Colors.white,),
              ],
            ),
        ),
          ),

        ],
      ),

      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: ToggleSwitch(
                  minWidth: double.infinity,
                  minHeight: 50.0,
                  fontSize: 18.0,
                  cornerRadius: 20.0,
                  activeBgColor: [Colors.orangeAccent],
                  activeFgColor: Colors.black87,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.grey[900],
                  initialLabelIndex: 0,
                  totalSwitches: 2,
                  labels: ['On Screen', 'Volume Keys'],
                  onToggle: (index) async {
                    print('switched to: $index');

                    if(index == 1)
                      {



                        startListening();

                        print('switched to inside: $index');

                      }
                    else
                      {
                        stopListening();
                      }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0,right:14.0,top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left:10,right: 10,top: 2, bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              children:  [

                                Expanded(

                                  child: Text("${ result.getString('CounterName') ?? null }",
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(fontSize: 20,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400,letterSpacing: 0.5),),
                                ),
                                ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCounter())).then((value) {
                                setState(() {

                                });
                              });

                          //     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCounter()));
                          //     Navigator.push(context,MaterialPageRoute(builder: (context) =>
                          //     AddCounter())).then((value)
                          // { setState(() {}
                          // ););

                                    // _navigateAndDisplaySelection(context);

                                  },
                                  child: Card(
                                    color: Colors.orangeAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Edit",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.5)),
                                          SizedBox(width: 5,),
                                          Icon(Icons.edit,color: Colors.white70,size: 24
                                            ,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _totalCount = 0;
                                      _countComplete = 0;
                                    });
                                  },
                                  child: Card(
                                    color: Colors.orangeAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Reset",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.5)),
                                          SizedBox(width: 5,),
                                          Icon(Icons.refresh,color: Colors.white70,size: 24
                                            ,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0,right:14.0,top: 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left:10,right: 10,top: 2, bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:  [
                          Text("${ result.getString('CounterValue') ?? null}" ,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,letterSpacing: 0.5),),
                          SizedBox(width: 10,),
                          Text("X",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,letterSpacing: 0.5),),
                          SizedBox(width: 10,),
                          Card(
                            elevation: 1,
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                width: 50,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text("$_countComplete",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),)),
                              ),
                            ),

                          ),
                          SizedBox(width: 10,),

                          Text("Total" ,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,letterSpacing: 0.5),),
                          SizedBox(width: 10,),
                          Text("X",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,letterSpacing: 0.5),),
                          SizedBox(width: 10,),
                          Card(
                            elevation: 1,
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                width: 50,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text("$_totalCount",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),)),
                              ),
                            ),

                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:5.0),
                child: Center(
                    child: GestureDetector(
                        onTap: () {
                          setState(() {

                            if(_totalCount > 0 )
                              {


                                _totalCount--;



                                if(_totalCount % int.parse(result.getString('CounterValue').toString())  == 0){


                                  if(_countComplete != 0 ) {
                                    _countComplete--;
                                  }

                                }

                              }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(40.0),//I used some padding without fixed width and height
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,// You can use like this way or like the below line
                            color: Colors.orangeAccent,
                          ),
                          //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.only(top:.0,left: 8,right: 8),
                child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {

                          _totalCount++;

                          if(_totalCount % int.parse(result.getString('CounterValue').toString())  == 0){
                            _countComplete++;

                          }


                        });
                      },
                        child: Container(
                          padding: const EdgeInsets.all(200.0),//I used some padding without fixed width and height
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,// You can use like this way or like the below line
                            color: Colors.orangeAccent,
                          ),
                          //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                        ))),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom:8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isBannerAdReady)
              Container(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
          ],
        ),
      ),


    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {


    // result = await Navigator.push(context,MaterialPageRoute(builder: (context) => Page2())).then((value) { setState(() {});


    // result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => AddCounter()),
    // ).then((value) { setState(() {});
    //
    // setState(() {
    //
    // });
  }
}
