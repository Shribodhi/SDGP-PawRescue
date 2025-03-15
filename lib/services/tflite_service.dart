import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
        'assets/models/food_recommendation_model.tflite');
    print("✅ Model loaded successfully!");
  }

  List<double> predict(List<double> inputData) {
    var output = List.filled(1, 0.0)
        .reshape([1, 1]); // Adjust shape based on model output

    _interpreter.run(inputData.reshape([1, inputData.length]), output);
    return output[0];
  }

  void close() {
    _interpreter.close();
  }
}
