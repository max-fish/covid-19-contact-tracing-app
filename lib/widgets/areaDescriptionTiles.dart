import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/covidMarkerModel.dart';
import 'package:flutter/material.dart';

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
      height: 200,
      child: PageView.builder(
          controller: widget.pageController,
          onPageChanged: (int index) {
            final CovidMarkerModel markerModel = widget.covidData[index];
            final LatLng newPos =
                LatLng(markerModel.latitude, markerModel.longitude);
            widget.googleMapController
                .animateCamera(CameraUpdate.newLatLng(newPos));
          },
          itemCount: widget.covidData.length,
          itemBuilder: (context, i) {
            return (Container(
              child: Column(
                children: [
                  Text(widget.covidData[i].areaName),
                  Text(widget.covidData[i].newCases.toString())
                ],
              ),
            ));
          }),
    );
  }
}
