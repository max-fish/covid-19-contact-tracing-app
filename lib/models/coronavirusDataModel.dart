class CoronavirusDataModel {
  final String areaName;
  final int newCases;

  const CoronavirusDataModel({this.areaName, this.newCases});

  factory CoronavirusDataModel.fromJson(Map<String, dynamic> json) {
    return CoronavirusDataModel(
      areaName: json['areaName'],
      newCases: json['newCases'],
    );
  }
}