import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:japa_counter/Boxes/boxes.dart';
import 'package:japa_counter/model/counter_model.dart';
import 'package:japa_counter/screens/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AdHelper/adshelper.dart';


class AddCounter extends StatefulWidget {
  const AddCounter({Key? key}) : super(key: key);

  @override
  State<AddCounter> createState() => _AddCounterState();
}

class _AddCounterState extends State<AddCounter> {



  TextEditingController textController = TextEditingController();
  TextEditingController countController = TextEditingController();
  final _personFormKey = GlobalKey<FormState>();
  late final Box box;


  String displayText = "";

  Future<void>? _launched;

  late BannerAd _bannerAd;

  bool _isBannerAdReady = false;
  int selectedValue = -1; // Initial value for the selected radio button
  var checkEdit = -1;
  late CounterModel counterModel;
  late SharedPreferences prefs;

  @override
  void initState() {


    super.initState();

    _loadLastSelectedValue();

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitIdOfHomeScreen,
      request: AdRequest(),
      size: AdSize.largeBanner,
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
    setState(() {
      selectedValue = prefs.getInt('selectedValue') ?? -1;
      var cN = prefs.getString('CounterName');
      var cV = prefs.getString('CounterValue');

      print("--"+selectedValue.toString());
      print("--"+cN.toString());
      print("--"+cV.toString());

    });
  }


  _saveSelectedValue(int value,String cName,String cValue ) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedValue', value);
    prefs.setString('CounterName', cName);
    prefs.setString('CounterValue', cValue);
  }



  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();

                  // setState(() {});

                  // Navigator.push( context, MaterialPageRoute( builder: (context) => HomeScreen()), ).then((value) => setState(() {}));

                }

              ),
            ),
            backgroundColor: Colors.orange,
            title: Text("Set New Counter",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,letterSpacing: 0.5),)),

    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(

              decoration: InputDecoration
                (
                  labelText: "Counter Name",
                  hintText: "Ex. Counter A",
                labelStyle: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500
                ),
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: Colors.orange),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: Colors.orange),
                ),
                prefixIcon: Icon(Icons.circle,color: Colors.orange,),
              ),
              controller: textController,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20.0,right: 20.0),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              maxLength: 3,
              decoration: InputDecoration
                (
                labelText: "Counter Value",
                hintText: "Ex. 108",
                labelStyle: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500
                ),
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: Colors.orange),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: Colors.orange),
                ),
                prefixIcon: Icon(Icons.timer,color: Colors.orange,),
              ),
              controller: countController,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          shadowColor: Colors.grey),
                      onPressed: ()  {

                        Navigator.pop(context, prefs);

                        },
                       child: Text("Cancel",style: TextStyle(fontSize:16.0,color: Colors.white,fontWeight: FontWeight.w600,letterSpacing: 0.8),)),
                ),

                Container(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          shadowColor: Colors.grey),
                      onPressed: () async{



                        if(checkEdit == 1)
                          {

                            counterModel.counterName = textController.text.toString();
                            counterModel.counterValue = countController.text.toString();

                            counterModel.save();

                            textController.clear();
                            countController.clear();

                            checkEdit = -1;
                          }
                        else
                          {

                            final data = CounterModel(counterName: textController.text.toString(), counterValue: countController.text.toString());

                            final boxes = Boxes.getData();
                            boxes.add(data);

                            data.save();


                          textController.clear();
                          countController.clear();
                          }


                      }, child: Text("Save",style: TextStyle(fontSize:16.0,color: Colors.white,fontWeight: FontWeight.w600,letterSpacing: 0.8),)),
                ),

              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Box<CounterModel>>(
                valueListenable: Boxes.getData().listenable(),
                builder: (context,box,_)
                {
                  var data = box.values.toList().cast<CounterModel>();
                  return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context,index) {
                        return Card(
                          child: RadioListTile(
                            activeColor: Colors.orange,
                            visualDensity:  VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                            value: index,
                            groupValue: selectedValue,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0,top: 8.0),
                                      child: Text("Name: " +data[index].counterName.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                                    ),

                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {

                                              checkEdit = 1;
                                              counterModel = data[index];
                                              textController.text = data[index].counterName.toString();
                                              countController.text = data[index].counterValue.toString();

                                            },
                                            child: Icon(Icons.edit,color: Colors.grey.shade600,)),
                                        SizedBox(width: 10.0,),
                                        InkWell(
                                            onTap: () {
                                              deleteCounter(data[index]);
                                            },
                                            child: Icon(Icons.delete,color: Colors.grey.shade600)),

                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0,top: 8.0),
                                  child: Text("Value: " +data[index].counterValue.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                                ),


                              ],
                            ),
                            onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
                              print(data[index].counterValue.toString());

                              _saveSelectedValue(selectedValue,data[index].counterName.toString(),data[index].counterValue.toString());

                              // Navigator.pop(context);

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen())).then((value) {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              });

                            });
                          },
                          ),
                        );
                      });
                }

            ),
          )

        ],
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

  void deleteCounter(CounterModel counterModel) async
  {
    checkEdit = -1;
    await counterModel.delete();
  }


}
