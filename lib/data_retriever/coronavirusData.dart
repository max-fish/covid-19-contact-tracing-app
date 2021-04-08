import 'dart:convert';
import '../models/coronavirusDataModel.dart';
import '../utilities/dates.dart';
import 'package:http/http.dart' as http;

// A class that handles retrieving covid data from the uk gov api
// This class uses the http library to request data
class CoronavirusData {

  //gets upper and lower tier local authority data and merges them
  static Future<List<CoronavirusDataModel>> getAllTierCovidData() async {
    final List<CoronavirusDataModel> upperTierCovidData = await _getTierData(true);
    final List<CoronavirusDataModel> lowerTierCovidData = await _getTierData(false);
    return [...upperTierCovidData, ...lowerTierCovidData];
  }

  //gets either upper tier or lower tier local authority data
  static Future<List<CoronavirusDataModel>> _getTierData(bool upperTierData) async {
    final String yesterdayDate = DateUtils.yesterdayYearMonthDay;
    final String beforeYesterdayDate = DateUtils.dayBeforeYesterdayYearMonthDay;

    final response = await http.get('https://api.coronavirus.data.gov.uk/v1/data?filters=areaType=${upperTierData ? 'utla' : 'ltla'};date=${yesterdayDate}&structure={"date": "date", "areaName": "areaName", "areaCode": "areaCode", "newCases": "newCasesByPublishDate"}');
    final yesterdayResponse = await http.get('https://api.coronavirus.data.gov.uk/v1/data?filters=areaType=${upperTierData ? 'utla' : 'ltla'};date=${beforeYesterdayDate}&structure={"newCases": "newCasesByPublishDate"}');

    if(response.statusCode == 200 && yesterdayResponse.statusCode == 200) {
      final String covidCasesString = response.body;
      final String yesterdayCovidCasesString = yesterdayResponse.body;

      final covidCasesJson = jsonDecode(covidCasesString);
      final yesterdayCovidCasesJson = jsonDecode(yesterdayCovidCasesString);

      final covidCasesList = covidCasesJson['data'] as List;
      final yesterdayCovidCasesList = yesterdayCovidCasesJson['data'] as List;

      _combineCovidDataForTwoDays(covidCasesList, yesterdayCovidCasesList);

      final List<CoronavirusDataModel> covidModels = covidCasesList.map((element) => CoronavirusDataModel.fromJson(element)).toList();
      return covidModels;
    }
    else {
      throw Exception('Failed to load utla COVID data');
    }
  }

  //adds new cases from the day before as yesterday cases into the more recent list
  static _combineCovidDataForTwoDays(List todayCovidList, List yesterdayCovidList) {
    for(int i = 0; i < todayCovidList.length; i++){
      todayCovidList[i]['yesterdayCases'] = yesterdayCovidList[i]['newCases'];
    }
  }
}