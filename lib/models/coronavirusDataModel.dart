// Value object for a covid data entity from the uk gov api
class CoronavirusDataModel {
  final String areaName;
  final String areaCode;
  final int newCases;
  final int yesterdayCases;

  const CoronavirusDataModel({this.areaName, this.areaCode, this.newCases, this.yesterdayCases});

  //makes a CoronaVirusDataModel object from the json that is retrieved from the api
  factory CoronavirusDataModel.fromJson(Map<String, dynamic> json) {
    return CoronavirusDataModel(
      areaName: json['areaName'],
      newCases: json['newCases'],
      areaCode: json['areaCode'],
      yesterdayCases: json['yesterdayCases']
    );
  }
}