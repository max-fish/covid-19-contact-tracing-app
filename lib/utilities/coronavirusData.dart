import 'dart:convert';
import '../models/coronavirusDataModel.dart';
import 'dates.dart';
import 'package:http/http.dart' as http;

class CoronavirusData {
  static Future<http.Response> getLocalDataFromAreaCode(String areaCode) {
    return http.get('https://api.coronavirus.data.gov.uk/v1/data?', headers: <String, String>{
      'filters': 'areaCode=${areaCode}'
    });
  }

  static Future<List<CoronavirusDataModel>> getUpperTierData() async {
    final String date = DateUtils.currentYearMonthDay;
    final response = await http.get('https://api.coronavirus.data.gov.uk/v1/data?filters=areaType=utla;date=${date}&structure={"date": "date", "areaName": "areaName", "newCases": "newCasesByPublishDate"}');

    if(response.statusCode == 200) {
      final String covidCasesString = response.body;
      final covidCasesJson = jsonDecode(covidCasesString);
      final covidCasesList = covidCasesJson['data'] as List;
      final List<CoronavirusDataModel> covidModels = covidCasesList.map((element) => CoronavirusDataModel.fromJson(element)).toList();
      return covidModels;
    }
    else {
      throw Exception('Failed to load utla COVID data');
    }
  }

  static Future<List<CoronavirusDataModel>> getLowerTierData() async {
    final String date = DateUtils.currentYearMonthDay;

    final response = await http.get('https://api.coronavirus.data.gov.uk/v1/data?filters=areaType=ltla;date=${date}&structure={"date": "date", "areaName": "areaName", "newCases": "newCasesByPublishDate"}');

    if(response.statusCode == 200) {
      final String covidCasesString = response.body;
      final covidCasesJson = jsonDecode(covidCasesString);
      final covidCasesList = covidCasesJson['data'] as List;
      final List<CoronavirusDataModel> covidModels = covidCasesList.map((element) => CoronavirusDataModel.fromJson(element)).toList();
      return covidModels;
    }
    else {
      throw Exception('Failed to load ltla COVID data');
    }
  }
}