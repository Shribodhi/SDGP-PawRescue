import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'pet_activity_page.dart';

class PetLocationPage extends StatefulWidget {
  final String trackerId;
  final bool isSmartTracker;

  const PetLocationPage({
    super.key,
    required this.trackerId,
    required this.isSmartTracker,
  });

  @override
  State<PetLocationPage> createState() => _PetLocationPageState();
}

class _PetLocationPageState extends State<PetLocationPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  String _petName = '';
  String _petType = '';
  Position? _currentPosition;
  LatLng? _petPosition;
  StreamSubscription<DocumentSnapshot>? _trackerSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadPetDetails();
    _setupLocationListener();
  }

  @override
  void dispose() {
    _trackerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _updateMarkers();
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> _loadPetDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('trackers')
          .doc(widget.trackerId)
          .get();

      if (!doc.exists) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      
      // Extract location data based on your Firebase structure
      final location = data['lastKnownLocation'] as Map<String, dynamic>;
      
      setState(() {
        _petName = data.containsKey('petName') ? data['petName'] as String : 'Unknown Pet';
        _petType = data.containsKey('petType') ? data['petType'] as String : 'Unknown';
        _petPosition = LatLng(
          location['latitude'] as double,
          location['longitude'] as double,
        );
        _isLoading = false;
      });

      print("Loaded pet details: $_petName, $_petType, position: $_petPosition");
      _updateMarkers();
    } catch (e) {
      print('Error loading pet details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setupLocationListener() {
    _trackerSubscription = FirebaseFirestore.instance
        .collection('trackers')
        .doc(widget.trackerId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      if (!data.containsKey('lastKnownLocation')) return;
      
      final location = data['lastKnownLocation'] as Map<String, dynamic>;

      setState(() {
        _petPosition = LatLng(
          location['latitude'] as double,
          location['longitude'] as double,
        );
      });

      _updateMarkers();
    });
  }

  void _updateMarkers() {
    if (_petPosition == null) return;

    setState(() {
      _markers.clear();

      // Add pet marker
      _markers.add(
        Marker(
          markerId: const MarkerId('pet'),
          position: _petPosition!,
          infoWindow: InfoWindow(
            title: _petName,
            snippet: 'Your $_petType',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );

      // Add current location marker if available
      if (_currentPosition != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('current'),
            position: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            infoWindow: const InfoWindow(
              title: 'Your Location',
              snippet: 'You are here',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );
      }

      // Update camera position to show both markers
      if (_mapController != null && _petPosition != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_petPosition!, 15),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoading ? 'Loading...' : '$_petName\'s Location'),
        backgroundColor: Colors.orange,
        actions: [
          if (widget.isSmartTracker)
            IconButton(
              icon: const Icon(Icons.monitor_heart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetActivityPage(
                      trackerId: widget.trackerId,
                      petName: _petName,
                    ),
                  ),
                );
              },
              tooltip: 'View Activity',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                // Demo mode banner
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.blue.withOpacity(0.1),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Demo Mode: Viewing tracker data without login',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _petPosition ?? const LatLng(0, 0),
                      zoom: 15,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      _updateMarkers();
                    },
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapToolbarEnabled: true,
                    zoomControlsEnabled: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _petName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            _petType == 'Dog'
                                ? Icons.pets
                                : _petType == 'Cat'
                                    ? Icons.pets
                                    : Icons.pets,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _petType,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            widget.isSmartTracker
                                ? Icons.bluetooth_connected
                                : Icons.location_on,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.isSmartTracker
                                ? 'PR Smart Tracker'
                                : 'Third Party Tracker',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (widget.isSmartTracker)
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetActivityPage(
                                  trackerId: widget.trackerId,
                                  petName: _petName,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.monitor_heart),
                          label: const Text('View Activity Data'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}