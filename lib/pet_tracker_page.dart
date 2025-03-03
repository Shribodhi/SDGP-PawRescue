import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_tracker.dart';

class PetTrackerPage extends StatefulWidget {
  const PetTrackerPage({super.key});

  @override
  State<PetTrackerPage> createState() => _PetTrackerPageState();
}

class _PetTrackerPageState extends State<PetTrackerPage> {
  GoogleMapController? _mapController;
  String? _selectedTrackerId;
  final Set<Marker> _markers = {};
  List<QueryDocumentSnapshot> _trackers = [];

  @override
  void initState() {
    super.initState();
    _loadTrackers();
  }

  Future<void> _loadTrackers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('trackers')
          .where('ownerId', isEqualTo: user.uid)
          .get();

      setState(() {
        _trackers = snapshot.docs;
        if (_trackers.isNotEmpty && _selectedTrackerId == null) {
          _selectedTrackerId = _trackers.first.id;
          _updateMapMarker(_trackers.first);
        }
      });
    } catch (e) {
      print('Error loading trackers: $e');
    }
  }

  void _updateMapMarker(QueryDocumentSnapshot tracker) {
    final data = tracker.data() as Map<String, dynamic>;
    final location = data['lastKnownLocation'] as Map<String, dynamic>;
    final position = LatLng(
      location['latitude'] as double,
      location['longitude'] as double,
    );

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(tracker.id),
          position: position,
          infoWindow: InfoWindow(
            title: data['petName'] as String,
            snippet: 'Last updated: ${location['timestamp']}',
          ),
        ),
      );

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track your pet'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _selectedTrackerId,
              decoration: const InputDecoration(
                labelText: 'Select Pet',
                border: OutlineInputBorder(),
              ),
              items: _trackers.map((tracker) {
                final data = tracker.data() as Map<String, dynamic>;
                return DropdownMenuItem(
                  value: tracker.id,
                  child: Text(data['petName'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTrackerId = value;
                  final tracker = _trackers.firstWhere((t) => t.id == value);
                  _updateMapMarker(tracker);
                });
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _trackers.map((tracker) {
                final data = tracker.data() as Map<String, dynamic>;
                final isSelected = tracker.id == _selectedTrackerId;
                return Card(
                  elevation: isSelected ? 4 : 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? Colors.orange : Colors.grey,
                      child: Text(
                        data['petName'].toString()[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(data['petName'] as String),
                    subtitle: Text('Type: ${data['petType']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        setState(() {
                          _selectedTrackerId = tracker.id;
                          _updateMapMarker(tracker);
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterTrackerPage()),
          ).then((_) => _loadTrackers());
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}