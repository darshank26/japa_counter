
import 'package:hive/hive.dart';
part 'counter_model.g.dart';

@HiveType(typeId: 0)
class CounterModel extends HiveObject {

  @HiveField(0)
  String counterName;

  @HiveField(1)
  String counterValue;

  CounterModel({required this.counterName, required this.counterValue });
  
}