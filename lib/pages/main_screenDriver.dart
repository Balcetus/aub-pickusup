import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'RideInfo_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final User? user = FirebaseAuth.instance.currentUser;
final String userId = user!.uid;
final FirebaseAuth _auth = FirebaseAuth.instance;

//getCurrentUserId to get the current user's ID using the FirebaseAuth instance that we created above
String? getCurrentUserId() {
  final User? user = _auth.currentUser;
  if (user != null) {
    return user.uid;
  }
  return null;
}

class Driverscreen extends StatefulWidget {
  const Driverscreen({Key? key}) : super(key: key);

  @override
  State<Driverscreen> createState() => _DriverscreenState();
}


class _DriverscreenState extends State<Driverscreen> {
  TextEditingController _controller=TextEditingController();

  static const CameraPosition _cameraPosition= CameraPosition(
    target: LatLng(33.899787466379394, 35.480203404979),// this have to be connected to the database
    zoom: 15,
  );

  late GoogleMapController _mapController;
  //the Uuid object is created to generate a unique session token for the Google Places API requests.
  var uuid = Uuid();
  String _sessionToken="12345";
  List<dynamic> _placesList=[];//placesList list is initialized to an empty list to store the suggestions returned by the Google Places API.
  

  @override
  void initState(){// to initialize the _controller and set a listener on it to call onChange when the text changes.
    //todo
    super.initState();
    _controller.addListener(() {
      onChange();
    });
  }

void onChange(){//generates a new sessionToken if it is null, and calls getSuggestions to get suggestions from the Google Places API.
    if(_sessionToken == null){
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggesion(_controller.text);
}

// constructs a request URL with the input text and the session token, sends an HTTP GET request to the Google Places API,
// and updates the _placesList with the suggestions returned by the API.
void getSuggesion(String input) async{
   String kPlACES_API_KEY="AIzaSyDNnWldPx48hApWjLEhXLDCKWlDwZmKDXU";
   String baseURL= 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
   String request = '$baseURL?input=$input&key=$kPlACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print('data');
    print(data);

    if(response.statusCode == 200){
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    }else{
      throw Exception('Failed to load data');
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
            children: <Widget>[
              GoogleMap(
                  onMapCreated: (GoogleMapController mapController) {
                    _mapController = mapController;
                  },
                  initialCameraPosition: _cameraPosition
              ),
              Positioned(
                top: 50,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to profile page
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('image/download.png'),
                  ),
                ),
              ),

             Padding(padding:const EdgeInsets.only(top: 100.0),

               child:Column(
                      children:[
                        Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 16),
                              Icon(Icons.search),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText: 'Choose your destination',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                        //The suggestions list is implemented as a ListView.builder widget that displays the suggestions stored in _placesList.

                            child: ListView.builder(
                              itemCount: _placesList.length,
                              itemBuilder: (context,index){
                              // Each suggestion is represented by a ListTile widget that displays the suggestion text and navigates the user to the RideInfoScreen when tapped
                              return ListTile(
                                //In the onTap callback of each ListTile, the location information (latitude, longitude, and name)
                                // is extracted from the suggestion text using the locationFromAddress function from the geocoding package,
                                // and passed to the RideInfoScreen widget along with the UserId.
                                onTap: () async {
                                  List<Location> locations = await locationFromAddress(_placesList[index]['description']);
                                  String name = _placesList[index]['description'];
                                  double latitude = locations.last.latitude;
                                  double longitude = locations.last.longitude;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RideInfoScreen(
                                         placeName: name, latitude: latitude, longitude: longitude, userId:userId ,
                                      ),
                                    ),
                                  );
                                },
                                title: Text(
                                  _placesList[index]['description'],
                                  style: TextStyle(
                                    color: Colors.black, // Set text color here
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                tileColor: Colors.white,
                              );
                        })


                        ),
                    ]),
                  ),

              ],
          )
      );

  }

}
