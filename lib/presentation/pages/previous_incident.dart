import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';
import '../widgets/previous_incident_card.dart';
import '../widgets/menu.dart';

class PreviousIncidentsPage extends StatefulWidget {
  const PreviousIncidentsPage({super.key});

  @override
  State<PreviousIncidentsPage> createState() => _PreviousIncidentsPageState();
}

class _PreviousIncidentsPageState extends State<PreviousIncidentsPage> {
  String? selectedLocation;
  final List<String> locations = ['6 kilo', '5 kilo', '4 kilo', 'sefereselam', 'lideta'];

  List<Map<String, dynamic>> _allIncidents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIncidents();
  }

  Future<void> _loadIncidents() async {
    final incidents = await ApiService().getIncidents();
    setState(() {
      _allIncidents = incidents;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredIncidents = selectedLocation == null
        ? _allIncidents
        : _allIncidents.where((incident) => incident['location'] == selectedLocation).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFD07C7C),
      endDrawer: const AppMenuDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF794747),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/pep.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text('Previous Incidents', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Image.asset('assets/menu.png', width: 24, height: 24, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'assets/rectangle.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 230,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDropdown(),
                const SizedBox(height: 24),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredIncidents.isEmpty
                          ? const Center(child: Text("No incidents found."))
                          :ListView.builder(
  itemCount: filteredIncidents.length,
  itemBuilder: (context, index) {
    final incident = filteredIncidents[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // uniform space between cards
      child: IncidentCardWidget(
        number: index + 1,
        title: incident['title'] ?? '',
        description: incident['description'] ?? '',
        location: incident['location'] ?? '',
      ),
    );
  },
),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Text('Choose your location', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        value: selectedLocation,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.brown),
        underline: const SizedBox(),
        onChanged: (value) {
          setState(() {
            selectedLocation = value;
          });
        },
        items: locations.map((String location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(location, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }
}
