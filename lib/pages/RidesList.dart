import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//This is a Flutter code that defines a stateless widget called UserScreen,
// which displays a list of rides retrieved from a Firestore database.


class RidesList extends StatelessWidget {
  final String userId;
//The RidesList widget takes a required parameter called userId of type String, which is not used in this code snippet.
 RidesList({required this.userId});





  @override
  Widget build(BuildContext context) {

    //Timer function that periodically checks if any ride's createdAt time is older than 24 hours,
    // and if so, marks the ride as "expired" by setting the expired field to true in the Firestore document.
    Timer.periodic(Duration(hours: 1), (timer) async {
      // It uses the Timer.periodic method to run a function every hour. The function retrieves all the rides from the Firestore database,
      // checks their createdAt time, and updates the expired field if necessary.
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('rides').get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Timestamp createdAt = (doc.data() as Map)['createdAt'];
        if (DateTime.now().difference(createdAt.toDate()).inHours >= 24) {
          doc.reference.update({'expired': true});
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Rides'),
      ),

      //The StreamBuilder widget listens to a stream of Firestore snapshots that contain the rides data,
      // and filters out any rides that have already expired by querying for rides where expired is equal to false.
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rides').where('expired', isEqualTo: false).snapshots(),

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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${ride['numberOfPassengers']} passengers'),
                    Text('Phone: ${ride['phoneNumber']}'),
                  ],
                ),
                trailing: Text(ride['rideTime']),
              );
            },
          );
        },
      ),
    );
  }
}
