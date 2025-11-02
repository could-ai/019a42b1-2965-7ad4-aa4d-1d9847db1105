import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Satellite Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
      ),
      home: const SatelliteTrackerPage(),
    );
  }
}

class SatelliteTrackerPage extends StatefulWidget {
  const SatelliteTrackerPage({super.key});

  @override
  State<SatelliteTrackerPage> createState() => _SatelliteTrackerPageState();
}

class _SatelliteTrackerPageState extends State<SatelliteTrackerPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _satellites = [];
  bool _isLoading = false;
  String _errorMessage = '';

  void _searchSatellites(String query) async {
    if (query.isEmpty) {
      setState(() {
        _satellites = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Using mock data for demonstration. In a real app, you would call a satellite tracking API.
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      if (query.toLowerCase().contains('starlink')) {
        _satellites = [
          {'satid': 55000, 'satname': 'STARLINK-1007', 'satlat': 45.123, 'satlng': -93.456},
          {'satid': 55001, 'satname': 'STARLINK-1008', 'satlat': 42.987, 'satlng': -95.654},
        ];
      } else if (query.toLowerCase().contains('iss')) {
         _satellites = [
          {'satid': 25544, 'satname': 'ISS (ZARYA)', 'satlat': -10.123, 'satlng': 120.456},
        ];
      } else {
        _satellites = [];
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Satellite Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a satellite (e.g., ISS, Starlink)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchSatellites(_searchController.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                _searchSatellites(value);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)));
    }

    if (_satellites.isEmpty && _searchController.text.isNotEmpty) {
      return const Center(child: Text('No satellites found. Try "ISS" or "Starlink".'));
    }
    
    if (_satellites.isEmpty) {
        return const Center(child: Text('Search for a satellite to begin.'));
    }

    return ListView.builder(
      itemCount: _satellites.length,
      itemBuilder: (context, index) {
        final satellite = _satellites[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.satellite_alt),
            title: Text(satellite['satname']),
            subtitle: Text('ID: ${satellite['satid']}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SatelliteDetailPage(satellite: satellite),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SatelliteDetailPage extends StatelessWidget {
  final dynamic satellite;

  const SatelliteDetailPage({super.key, required this.satellite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(satellite['satname']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Satellite Name: ${satellite['satname']}', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('Satellite ID: ${satellite['satid']}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text('Latitude: ${satellite['satlat']}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text('Longitude: ${satellite['satlng']}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 32),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'This is where a sky map or 3D visualization of the satellite position would be displayed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
