import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/di/service_locator.dart';
import 'package:frontend/services/analysis_service.dart';
import 'package:frontend/constants/constants.dart' as constants;

class PredictionsOverlay extends StatefulWidget {
  const PredictionsOverlay({super.key});

  @override
  State<PredictionsOverlay> createState() => _PredictionsOverlayState();
}

class _PredictionsOverlayState extends State<PredictionsOverlay> {
  String _latestPredictionText = "Loading...";

  final List<String> _class = [];
  final List<List<int>> _userIdPrediction = [];
  final List<List<double>> _confidenceLevelPrediction = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _fetchPredictions();

    _timer = Timer.periodic(
      const Duration(seconds: constants.Properties.secondsBeforeSentToDb),
      (timer) {
        _fetchPredictions();
      },
    );
  }

  Future<void> _fetchPredictions() async {
    final analysisService = locator<AnalysisService>();

    final response = await analysisService.getPredictions();

    if (response.success && response.data != null) {
      setState(() {
        final predictionsList = response.data["predictions"];

        _latestPredictionText = "Waiting for new data...";

        for (final dataPrediction in predictionsList) {
          String className = dataPrediction["class"];
          _class.add(className);

          final predictions =
              (dataPrediction["predictions"]["prediction"] as List<dynamic>)
                  .cast<int>();
          _userIdPrediction.add(predictions);

          final confidences =
              (dataPrediction["predictions"]["confidence"] as List<dynamic>)
                  .cast<double>();
          _confidenceLevelPrediction.add(confidences);
        }

        List<String> displayLines = [];

        for (int i = 0; i < _userIdPrediction.length; i++) {
          final className = _class[i];
          final predictions = _userIdPrediction[i];
          final confidences = _confidenceLevelPrediction[i];

          List<String> lines = List.generate(predictions.length, (j) {
            return "${predictions[j]} -> ${confidences[j].toStringAsFixed(4)}";
          });

          displayLines.add("$className:\n${lines.join('\n')}");
        }

        if (displayLines.isNotEmpty) {
          _latestPredictionText = displayLines.join('\n\n');
          print(_latestPredictionText);
        }

        if (_userIdPrediction.length > 5) {
          _userIdPrediction.clear();
          _confidenceLevelPrediction.clear();
          _class.clear();
        }
      });
    } else {
      setState(() {
        _latestPredictionText = "Error fetching predictions";
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: const EdgeInsets.all(50),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _latestPredictionText,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
