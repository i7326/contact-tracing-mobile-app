import 'package:coloc/contact_repository/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'home.dart';
import 'package:flutter_blue_beacon/flutter_blue_beacon.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coloc/ui/pages/home/bloc/contact_bloc.dart';
import 'package:coloc/ui/pages/home/bloc/scan_bloc.dart';
import 'package:coloc/ui/pages/home/contacts.dart';
import 'package:coloc/user_repository/user_repositor.dart';
import 'package:location/location.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:coloc/ui/pages/home/bloc/flag_bloc.dart';
import 'package:coloc/flag_repository/flag_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  final UserRepository userRepository;
  Home({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  StreamController<Map> _beaconStreamController = new StreamController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FlutterBlueBeacon _flutterBlueBeacon = FlutterBlueBeacon.instance;
  BeaconBroadcast _beaconBroadcast = BeaconBroadcast();
  List beacons = new List();
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  Map _beacons = new Map();
  StreamSubscription _scanSubscription;
  StreamSubscription _stateSubscription;
  Location location = new Location();
  LocationData _locationData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _beaconStreamController.close();
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    super.dispose();
  }

  _startScan(String uuid, cb) async {
    _beaconBroadcast
        .setUUID(uuid)
        .setMajorId(1)
        .setMinorId(100)
        .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
        .setManufacturerId(0x004c)
        .start();
    _scanSubscription = _flutterBlueBeacon.scan().listen((beacon) async {
      if (beacon is IBeacon &&
          beacon.distance < 12 &&
          !beacons.contains(beacon.uuid)) {
        _locationData = await location.getLocation();
        setState(() {
          beacons.add(beacon.uuid);
        });
        cb({
          "id":
              "${beacon.uuid.substring(0, 8)}-${beacon.uuid.substring(8, 12)}-${beacon.uuid.substring(12, 16)}-${beacon.uuid.substring(16, 20)}-${beacon.uuid.substring(20, 32)}",
          "location": "${_locationData.latitude},${_locationData.longitude}",
          "type": "others",
          "timestamp": new DateTime.now().millisecondsSinceEpoch
        });
      }
    }, onDone: () {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ScanBloc>(
            create: (BuildContext context) => ScanBloc(
                userRepository: RepositoryProvider.of<UserRepository>(context)),
          ),
          BlocProvider<ContactBloc>(
            create: (BuildContext context) => ContactBloc(
                userRepository: RepositoryProvider.of<UserRepository>(context),
                repository: RepositoryProvider.of<ContactRepository>(context)),
          ),
          BlocProvider<FlagBloc>(
            create: (BuildContext context) => FlagBloc(
                userRepository: RepositoryProvider.of<UserRepository>(context),
                flagRepository: RepositoryProvider.of<FlagRepository>(context)),
          )
        ],
        child: BlocBuilder<ScanBloc, ScanState>(builder: (context, state) {
          if (state is ScanInitial) {
            final android = AndroidInitializationSettings('mipmap/ic_launcher');
            final ios = IOSInitializationSettings();
            final initalization = InitializationSettings(android, ios);
            final androidDetails = new AndroidNotificationDetails(
                "channelId", "channelName", "channelDescription");
            final iosDetails = new IOSNotificationDetails();
            flutterLocalNotificationsPlugin.initialize(initalization);
            final notificationDetails =
                NotificationDetails(androidDetails, iosDetails);
            _firebaseMessaging.configure(
              onMessage: (Map<String, dynamic> message) {
                flutterLocalNotificationsPlugin.show(
                    0, message['title'], message['body'], notificationDetails);
                BlocProvider.of<FlagBloc>(context).add(FetchFlag());
              },
              onResume: (Map<String, dynamic> message) {
                BlocProvider.of<FlagBloc>(context).add(FetchFlag());
              },
              onLaunch: (Map<String, dynamic> message) {
                BlocProvider.of<FlagBloc>(context).add(FetchFlag());
              },
            );
            _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
              if (s == BluetoothState.turningOff || s == BluetoothState.off) {
                BlocProvider.of<ScanBloc>(context).add(StopScanning());
              } else if (s == BluetoothState.on) {
                BlocProvider.of<ScanBloc>(context).add(StartScanning());
              }
            });
            BlocProvider.of<ScanBloc>(context).add(GetPermission());
          } else if (state is PermissionGranted) {
            BlocProvider.of<ScanBloc>(context).add(StartScanning());
          } else if (state is ScanningStarted) {
            _startScan(
                state.uuid,
                (Map<String, dynamic> device) =>
                    BlocProvider.of<ScanBloc>(context).add(AddDevice(
                        id: device["id"],
                        location: device["location"],
                        type: device["type"],
                        timestamp: device["timestamp"])));
            BlocProvider.of<ScanBloc>(context).add(StartListening());
          } else if (state is ProximityDetected) {
            BlocProvider.of<ContactBloc>(context).add(AddContact(
                id: state.device['id'],
                type: state.device['type'],
                location: state.device['location'],
                timestamp: state.device['timestamp']));
            BlocProvider.of<ScanBloc>(context).add(StartListening());
          }
          final List<Widget> _children = [
            HomeWidget(
                scanBloc: BlocProvider.of<ScanBloc>(context),
                flagBloc: BlocProvider.of<FlagBloc>(context)),
            ContactWidget(
              contactBloc: BlocProvider.of<ContactBloc>(context),
            ),
          ];
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  'COVID19 Tracker',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
              ),
              body: _children[_currentIndex],
              floatingActionButton: FloatingActionButton(
                tooltip: 'Increment',
                backgroundColor: Colors.red,
                onPressed: () {
                  BlocProvider.of<FlagBloc>(context).add(AddFlag(
                      timestamp: new DateTime.now().millisecondsSinceEpoch,
                      type: "suspicious"));
                },
                child: Text("Affected",
                    style: new TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              bottomNavigationBar: Container(
                child: BlocBuilder<ContactBloc, ContactState>(
                    builder: (context, state) {
                  return BottomNavyBar(
                    onItemSelected: (int index) {
                      if (index == 1)
                        BlocProvider.of<ContactBloc>(context)
                            .add(FetchContacts());
                      if (index == 0)
                        BlocProvider.of<FlagBloc>(context).add(FetchFlag());
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    selectedIndex: _currentIndex,
                    showElevation: true,
                    itemCornerRadius: 8,
                    curve: Curves.easeInBack,
                    items: [
                      BottomNavyBarItem(
                        icon: Icon(Icons.home),
                        title: Text(
                          'Home',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      BottomNavyBarItem(
                        icon: Icon(Icons.account_circle),
                        title: Text('Contacts'),
                        textAlign: TextAlign.center,
                      )
                    ],
                  );
                }),
              ));
        }));
  }
}
