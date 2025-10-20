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
              final lat = docs[index]['latitude'];
              final lng = docs[index]['longitude'];

              final timestamp = docs[index]['timestamp'];
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

              return ListTile(
                title: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Lat: $lat"),
                    Text("Lng: $lng"),
                    Text("Time: $formattedTime"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.person_pin_circle_outlined,
                    color: Colors.red,size: 35,
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
              );
            },
          );
        },
      ),
    );
  }
}
