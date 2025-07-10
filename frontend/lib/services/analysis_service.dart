import 'package:dio/dio.dart';
import 'package:frontend/models/custom_response.dart';
import 'package:frontend/constants/constants.dart' as constants;

class AnalysisService {
  final Dio _dio;

  AnalysisService(this._dio);

  Future<CustomResponse> getPredictions() async {
    try {
      final response = await _dio.get(constants.Strings.latestPredictionsPath);

      final responseBodyJson = response.data;

      if (response.statusCode == 200) {
        return CustomResponse(
          success: true,
          data: responseBodyJson,
          message: responseBodyJson[constants.Strings.responseMessageFieldName],
        );
      }

      return CustomResponse(
        success: false,
        message:
            responseBodyJson[constants.Strings.responseMessageFieldName][0],
      );
    } catch (e) {
      return CustomResponse(
        success: false,
        message: "GetPredictions error: $e",
      );
    }
  }
}
