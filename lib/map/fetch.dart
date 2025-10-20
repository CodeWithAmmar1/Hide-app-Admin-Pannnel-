import 'package:app/map/mapscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Fetch extends StatelessWidget {
  const Fetch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Fetch Screen",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('locations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final lat = data['latitude'];
              final lng = data['longitude'];
              final deviceName = data['device_name'] ?? "Unknown Device";
              final androidVersion = data['android_version'] ?? "N/A";
              final ipAddress = data['ip_address'] ?? "Unknown IP";
              final macAddress = data['mac_address'] ?? "Unknown MAC";
              final timestamp = data['timestamp'];
              DateTime dateTime;

              if (timestamp is Timestamp) {
                dateTime = timestamp.toDate();
              } else if (timestamp is int) {
                dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
              } else {
                dateTime = DateTime.now();
              }

              final formattedTime =
                  "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    "Device: $deviceName (Android $androidVersion)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lng: $lng"),
                      Text("Lat: $lat"),
                      Text("IP: $ipAddress"),
                      Text("MAC: $macAddress"),
                      Text("Time: $formattedTime"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => MapScreen(latitude: lat, longitude: lng),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
