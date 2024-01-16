import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocS extends StatelessWidget {
  LocS({Key? key});
  String googleApikey = "AIzaSyC1stPRMsTLwlxp9fP0vf0byrWjOUm7VbQ";
  GoogleMapController? mapController;
  LatLng startLocation = const LatLng(30.378180, 76.776695);
  String location = "Search Location";

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            scrollGesturesEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              target: startLocation,
              zoom: 14.0,
            ),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              mapController = controller;
            },
            markers: markers,
          ),
          Positioned(
            top: 10,
            child:
            InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: googleApikey,
                  mode: Mode.overlay,
                  types: [],
                  strictbounds: false,
                  components: [const Component(Component.country, 'in')],
                  onError: (err) {
                    print(err);
                  },
                );

                if (place != null) {
                  location = place.description.toString();
                  final plist = GoogleMapsPlaces(
                    apiKey: googleApikey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                  );

                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lng = geometry.location.lng;

                  // Fetch nearby places with a specific radius and filter for Pet Hospitals
                  var nearbyPlaces = await plist.searchNearbyWithRadius(
                    Location(lng: lng, lat: lat),
                    5000,
                    type: "pet_hospital", // Filter for Pet Hospitals
                  );

                  // Clear previous markers
                  markers.clear();
                 print("data   :   ${nearbyPlaces.results.first.name}");
                  // Add markers for each nearby place
                  for (var place in nearbyPlaces.results) {
                    markers.add(
                      Marker(
                        markerId: MarkerId(place.id!),
                        position: LatLng(
                          place.geometry!.location.lat,
                          place.geometry!.location.lng,
                        ),
                        infoWindow: InfoWindow(title: place.name),
                      ),
                    );
                  }

                  // Move map camera to the selected place with animation
                  if (markers.isNotEmpty) {
                    mapController?.animateCamera(
                      CameraUpdate.newLatLng(markers.first.position),
                    );
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      title: Text(
                        location,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.search),
                      dense: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
