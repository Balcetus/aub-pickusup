import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//This is a Flutter code that defines a stateless widget called UserScreen,
// which displays a list of rides retrieved from a Firestore database.


class UserScreen extends StatelessWidget {
  final String userId;
//The UserScreen widget takes a required parameter called userId of type String, which is not used in this code snippet.
  UserScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rides'),
      ),
      //The StreamBuilder widget listens to a stream of Firestore snapshots that contain the rides data.
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rides').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //If the snapshot has an error, the widget displays an error message. If the connection state is waiting, the widget displays a loading message.
          // Otherwise, it retrieves the list of rides from the snapshot, and displays them in a ListView.builder widget.
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }

          final List<DocumentSnapshot> rides = snapshot.data!.docs;
          final List<DocumentSnapshot> filteredRides = rides;

         // widget returns a ListView.builder widget that displays a list of rides.
          return ListView.builder(
            itemCount: filteredRides.length,
            itemBuilder: (BuildContext context, int index) {
              final ride = filteredRides[index];
              return ListTile(
                title: Text(ride['placeName']),
                subtitle: Text('${ride['numberOfPassengers']} passengers'),
                trailing: Text(ride['rideTime']),
              );
            },
          );
        },
      ),
    );
  }
}