
import 'package:flutter_test/flutter_test.dart';

_combineCovidDataForTwoDays(List todayCovidList, List yesterdayCovidList) {
  for(int i = 0; i < todayCovidList.length; i++){
    todayCovidList[i]['yesterdayCases'] = yesterdayCovidList[i]['newCases'];
  }
}

void main() {

  final todayCovidList = [{'areaName': 'test name', 'areaCode': '123456', 'newCases': 5}];
  const yesterdayCovidList = [{'areaName': 'test name', 'areaCode': '123456', 'newCases': 3}];

  test('Data retriever correctly combines data', () {
    _combineCovidDataForTwoDays(todayCovidList, yesterdayCovidList);

    final combinedCovidData = todayCovidList[0];

    expect(combinedCovidData['areaName'], 'test name');
    expect(combinedCovidData['areaCode'], '123456');
    expect(combinedCovidData['newCases'], 5);
    expect(combinedCovidData['yesterdayCases'], 3);
  });
}
