
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:japa_counter/screens/addCounter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Japa Counter",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,letterSpacing: 0.5),),
        backgroundColor: Colors.orange,
        actions: [
        // Padding(
        //   padding: const EdgeInsets.only(right:8.0),
        //   child: Text("New Counter",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 14)),
        // ),
          GestureDetector(
            onTap: () async{
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCounter()));
              
              var box  = await Hive.openBox('HiveDB');

              box.put('name', 'dsk');

              print(box.get('name'));

            },
            child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.add_box_outlined,size: 28,color: Colors.white,),
        ),
          ),
        ],
      ),

    );
  }
}
