import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class PetActivityPage extends StatefulWidget {
  final String trackerId;
  final String petName;

  const PetActivityPage({
    super.key,
    required this.trackerId,
    required this.petName,
  });

  @override
  State<PetActivityPage> createState() => _PetActivityPageState();
}

class _PetActivityPageState extends State<PetActivityPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  Map<String, dynamic>? _activityData;
  List<Map<String, dynamic>> _activityHistory = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadActivityData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadActivityData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current activity data
      final doc = await FirebaseFirestore.instance
          .collection('trackers')
          .doc(widget.trackerId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('activityData')) {
          setState(() {
            _activityData = data['activityData'] as Map<String, dynamic>;
          });
        } else {
          // If activityData doesn't exist as a separate field, check if it's directly in the document
          setState(() {
            _activityData = {
              'heart_rate': data.containsKey('heart_rate') ? data['heart_rate'] : 0,
              'steps': data.containsKey('steps') ? data['steps'] : 0,
              'timestamp': DateTime.now(),
            };
          });
        }
      }

      // For demo purposes, create some mock history data
      // In a real app, you'd fetch this from a subcollection
      final now = DateTime.now();
      final List<Map<String, dynamic>> mockHistory = [];
      
      for (int i = 0; i < 24; i++) {
        mockHistory.add({
          'heart_rate': 70 + (i % 5) * 10,
          'steps': 100 * i,
          'timestamp': Timestamp.fromDate(now.subtract(Duration(hours: i))),
        });
      }

      setState(() {
        _activityHistory = mockHistory;
        _isLoading = false;
      });
      
      print("Loaded activity data: $_activityData");
    } catch (e) {
      print('Error loading activity data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.petName}\'s Activity'),
        backgroundColor: Colors.orange,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Current'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCurrentActivityTab(),
                _buildActivityHistoryTab(),
              ],
            ),
    );
  }

  Widget _buildCurrentActivityTab() {
    if (_activityData == null) {
      return const Center(
        child: Text(
          'No activity data available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    final heartRate = _activityData!['heart_rate'] ?? 0;
    final steps = _activityData!['steps'] ?? 0;
    final lastUpdated = _activityData!['timestamp'] != null
        ? ((_activityData!['timestamp'] as Timestamp).toDate())
        : DateTime.now();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Activity',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            'Last updated: ${_formatDateTime(lastUpdated)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildActivityCard(
                  title: 'Heart Rate',
                  value: '$heartRate bpm',
                  icon: Icons.favorite,
                  color: Colors.red,
                  description: _getHeartRateDescription(heartRate),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActivityCard(
                  title: 'Steps',
                  value: steps.toString(),
                  icon: Icons.directions_walk,
                  color: Colors.green,
                  description: _getStepsDescription(steps),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Activity Status',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityStatusCard(heartRate, steps),
        ],
      ),
    );
  }

  Widget _buildActivityHistoryTab() {
    if (_activityHistory.isEmpty) {
      return const Center(
        child: Text(
          'No activity history available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    // Prepare data for charts
    final heartRateData = _activityHistory
        .map((data) => FlSpot(
              _activityHistory.indexOf(data).toDouble(),
              (data['heart_rate'] ?? 0).toDouble(),
            ))
        .toList();

    final stepsData = _activityHistory
        .map((data) => FlSpot(
              _activityHistory.indexOf(data).toDouble(),
              (data['steps'] ?? 0).toDouble(),
            ))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last 24 hours',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Heart Rate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: heartRateData,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Steps',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: stepsData,
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Activity Log',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activityHistory.length,
            itemBuilder: (context, index) {
              final data = _activityHistory[index];
              final timestamp = data['timestamp'] as Timestamp;
              final heartRate = data['heart_rate'] ?? 0;
              final steps = data['steps'] ?? 0;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(_formatDateTime(timestamp.toDate())),
                  subtitle: Text('Heart Rate: $heartRate bpm • Steps: $steps'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.withOpacity(0.2),
                    child: const Icon(
                      Icons.pets,
                      color: Colors.orange,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityStatusCard(int heartRate, int steps) {
    String status;
    Color statusColor;
    IconData statusIcon;
    String description;

    if (heartRate > 120 || steps > 5000) {
      status = 'Very Active';
      statusColor = Colors.green;
      statusIcon = Icons.directions_run;
      description = 'Your pet is very active today!';
    } else if (heartRate > 90 || steps > 2000) {
      status = 'Active';
      statusColor = Colors.lightGreen;
      statusIcon = Icons.directions_walk;
      description = 'Your pet is getting good exercise.';
    } else if (heartRate > 70 || steps > 500) {
      status = 'Moderately Active';
      statusColor = Colors.orange;
      statusIcon = Icons.pets;
      description = 'Your pet is moving around a bit.';
    } else {
      status = 'Resting';
      statusColor = Colors.blue;
      statusIcon = Icons.nightlight_round;
      description = 'Your pet is taking it easy right now.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: statusColor.withOpacity(0.2),
            radius: 30,
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getHeartRateDescription(int heartRate) {
    if (heartRate > 120) {
      return 'High - Your pet might be excited or active';
    } else if (heartRate > 90) {
      return 'Normal - Your pet is likely awake and alert';
    } else if (heartRate > 70) {
      return 'Low - Your pet might be resting';
    } else {
      return 'Very low - Your pet is likely sleeping';
    }
  }

  String _getStepsDescription(int steps) {
    if (steps > 5000) {
      return 'Very active day - Your pet is getting lots of exercise!';
    } else if (steps > 2000) {
      return 'Active day - Your pet is moving around well';
    } else if (steps > 500) {
      return 'Moderate activity - Some movement detected';
    } else {
      return 'Low activity - Your pet hasn\'t moved much today';
    }
  }
}