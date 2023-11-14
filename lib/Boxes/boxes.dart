

import 'package:hive/hive.dart';
import 'package:japa_counter/model/counter_model.dart';

class Boxes {

  static Box<CounterModel> getData() => Hive.box<CounterModel>('counter');

}