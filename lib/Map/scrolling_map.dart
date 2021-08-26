// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScrollingMapBody extends StatelessWidget {
  const ScrollingMapBody();

  final LatLng center = const LatLng(31.972052151608743, 35.8325189269803);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trucks Location"),
        backgroundColor: Color(0xFFFF0000),
      ),
      body: Center(
        child: Card(
          child: Center(
            child: GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: 15.0,
              ),
              markers: <Marker>{
                Marker(
                  markerId: MarkerId("Aumet_Jordan"),
                  position: LatLng(
                    center.latitude,
                    center.longitude,
                  ),
                  infoWindow: const InfoWindow(
                    title: 'Aumet Jordan',
                    snippet: '*',
                  ),
                ),
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => ScaleGestureRecognizer(),
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}
