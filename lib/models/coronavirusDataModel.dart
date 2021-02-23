class CoronavirusDataModel {
  final String areaName;
  final String areaCode;
  final int newCases;
  final int yesterdayCases;

  const CoronavirusDataModel({this.areaName, this.areaCode, this.newCases, this.yesterdayCases});

  factory CoronavirusDataModel.fromJson(Map<String, dynamic> json) {
    return CoronavirusDataModel(
      areaName: json['areaName'],
      newCases: json['newCases'],
      areaCode: json['areaCode'],
      yesterdayCases: json['yesterdayCases']
    );
  }
}