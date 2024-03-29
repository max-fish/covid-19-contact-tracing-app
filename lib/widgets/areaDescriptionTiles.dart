import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/covidMarkerModel.dart';
import 'package:flutter/material.dart';

// UI for data visualization of covid hotspots
class AreaDescriptionTiles extends StatefulWidget {
  final List<CovidMarkerModel> covidData;
  final PageController pageController;
  final GoogleMapController googleMapController;

  AreaDescriptionTiles(
      {this.covidData, this.pageController, this.googleMapController});

  @override
  _AreaDescriptionTilesState createState() => _AreaDescriptionTilesState();
}

class _AreaDescriptionTilesState extends State<AreaDescriptionTiles> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 210,
        // enables users to swipe through different hotspot data
        child: PageView.builder(
            controller: widget.pageController,
            onPageChanged: (int index) {
              final CovidMarkerModel markerModel = widget.covidData[index];
              final LatLng newPos =
                  LatLng(markerModel.latitude, markerModel.longitude);
              //move map to the location of the new hotspot data
              //from google_maps_flutter library
              widget.googleMapController
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newPos, zoom: 11)));
            },
            itemCount: widget.covidData.length,
            itemBuilder: (context, i) {
              //UI for a particular covid hotspot
              final int currentCases = widget.covidData[i].newCases;
              final int yesterdayCases = widget.covidData[i].yesterdayCases;
              final int caseChange = currentCases - yesterdayCases;
              return (Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Align(
                        alignment: const Alignment(-0.9, -0.8),
                        child: Text(widget.covidData[i].areaName,
                            style: Theme.of(context).textTheme.headline5),
                      ),
                      Align(
                        alignment: const Alignment(0, 0.3),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  currentCases.toString(),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                const Text('new cases')
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CaseLabel(caseChange: caseChange),
                                const Text('since yesterday')
                                ]),
                              ],
                            )
                      ),
                    ],
                  )));
            }));
  }
}

//displays the covid case difference from the previous day
class CaseLabel extends StatelessWidget {
  final int caseChange;

  const CaseLabel({@required this.caseChange});

  @override
  Widget build(BuildContext context) {
    if (caseChange < 0) {
      // if cases are lower than the day before
      return Row(
        children: [
          const Icon(
            Icons.south_rounded,
            color: Colors.green,
          ),
          Text(
            caseChange.toString(),
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.green),
          ),
        ],
      );
    } else if (caseChange == 0) {
      //if cases are then same as the day before
      return Row(children: [
        const Icon(Icons.horizontal_rule_rounded, color: Colors.blueGrey),
        Text(
          caseChange.toString(),
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.blueGrey),
        ),
      ]);
    } else {
      //if cases are bigger than the day before
      return Row(
        children: [
          const Icon(Icons.north_rounded, color: Colors.red),
          Text(
            '+' + caseChange.toString(),
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.red),
          ),
        ],
      );
    }
  }
}
