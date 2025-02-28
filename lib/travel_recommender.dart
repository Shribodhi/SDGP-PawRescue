import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class TravelRecommenderPage extends StatefulWidget {
  const TravelRecommenderPage({super.key});

  @override
  State<TravelRecommenderPage> createState() => _TravelRecommenderPageState();
}

class _TravelRecommenderPageState extends State<TravelRecommenderPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  List<Place> _nearbyPlaces = [];
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Jogging Areas', 'Pharmacies', 'Veterinarians'];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied';
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
      await _getNearbyPlaces();
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getNearbyPlaces() async {
    if (_currentPosition == null) return;

    final String apiKey = 'AIzaSyBN4ak6Umtd-Czy8eAlZ2oYT3b3iCDqvYY';
    final String baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

    List<String> types = ['park', 'pharmacy', 'veterinary_care'];
    _nearbyPlaces.clear();

    for (String type in types) {
      try {
        final response = await http.get(Uri.parse(
            '$baseUrl?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=1500&type=$type&key=$apiKey'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK') {
            for (var place in data['results']) {
              _nearbyPlaces.add(Place(
                name: place['name'],
                type: _getReadableType(type),
                latitude: place['geometry']['location']['lat'],
                longitude: place['geometry']['location']['lng'],
              ));
            }
          } else {
            print('API Error: ${data['status']}');
            throw 'API Error: ${data['status']}';
          }
        } else {
          print('HTTP Error: ${response.statusCode}');
          throw 'HTTP Error: ${response.statusCode}';
        }
      } catch (e) {
        print('Error fetching places: $e');
        setState(() {
          _errorMessage = 'Error fetching places: $e';
        });
      }
    }

    setState(() {});
  }

  String _getReadableType(String type) {
    switch (type) {
      case 'park':
        return 'Jogging Areas';
      case 'pharmacy':
        return 'Pharmacies';
      case 'veterinary_care':
        return 'Veterinarians';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Recommender'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Map View
          Container(
            height: 300,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : _currentPosition == null
                        ? const Center(child: Text('Location not available'))
                        : GoogleMap(
                            onMapCreated: (controller) => _mapController = controller,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                              zoom: 14,
                            ),
                            markers: _nearbyPlaces
                                .map((place) => Marker(
                                      markerId: MarkerId(place.name),
                                      position: LatLng(place.latitude, place.longitude),
                                      infoWindow: InfoWindow(title: place.name, snippet: place.type),
                                    ))
                                .toSet(),
                          ),
          ),
          
          // Category Filter
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: _selectedCategory == category,
                      label: Text(category),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      selectedColor: Colors.orange[100],
                      checkmarkColor: Colors.orange,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // List View
          Expanded(
            child: _nearbyPlaces.isEmpty
                ? Center(child: Text(_errorMessage.isEmpty ? 'No places found' : _errorMessage))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _nearbyPlaces.length,
                    itemBuilder: (context, index) {
                      final place = _nearbyPlaces[index];
                      if (_selectedCategory == 'All' || _selectedCategory == place.type) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            title: Text(place.name),
                            subtitle: Text(place.type),
                            trailing: IconButton(
                              icon: Icon(Icons.directions),
                              onPressed: () {
                                _launchMapsUrl(place.latitude, place.longitude);
                              },
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch $url');
      setState(() {
        _errorMessage = 'Could not launch maps';
      });
    }
  }
}

class Place {
  final String name;
  final String type;
  final double latitude;
  final double longitude;

  Place({required this.name, required this.type, required this.latitude, required this.longitude});
}