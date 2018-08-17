import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/polygon.dart';
import 'package:map_view/polyline.dart';
import 'package:map_view/figure_joint_type.dart';
import 'dart:async';
import 'httpGet.dart';
import 'ATM.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


List<Marker> _markers;
MapView mapView = new MapView();


void main(){
  MapView.setApiKey("AIzaSyASZaNC3WUXfTadEBs34JGx9GEDeb9Zfz8");
  runApp(new MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter ATM app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var atmlist = new List<ATM>();
  Database database;

  @override
  Widget build(BuildContext context) {
    showMap();
    /*// This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
    );*/
    return new Container();
  }

  showMap() async{
    await checkDB();
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            showMyLocationButton: true,
            title: "Flutter ATM"),
        //toolbarActions: [new ToolbarAction("Close", 1)]
    );

    mapView.onMapReady.listen((_) {
      mapView.setMarkers(_markers);
    });

    mapView.onMapTapped.listen((location){
      mapView.clearAnnotations();
      refillTable();
      mapView.setMarkers(_markers);
    });

  }

  getATMs() async {
    atmlist = await fetchATM();
  }

  addMarkers() async {
    _markers = new List<Marker>();

    int teller = 1;

    for(ATM atm in atmlist){
      _markers.add(new Marker(teller.toString(), atm.Agen, double.parse(atm.Coord[0]), double.parse(atm.Coord[1]), color: Colors.purple));
      teller++;
    }
  }

  checkDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "atm.db");

    //dev method
    //await deleteDatabase(path);

    bool newdb = false;

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              "CREATE TABLE `atms` (`Adresse` varchar(34) DEFAULT NULL,`Adress` varchar(29) DEFAULT NULL,`Agen` varchar(34) DEFAULT NULL,`Quoi` varchar(21) DEFAULT NULL,`Wat` varchar(12) DEFAULT NULL,`What` varchar(3) DEFAULT NULL,`Lat` varchar(28) DEFAULT NULL,`Long` varchar(28) DEFAULT NULL)");
          print("new db created");
          await getATMs();
          newdb = true;
    });

    if(newdb){
      await insertIntoTable();
    }

    List<Map> list = await database.rawQuery('SELECT * FROM atms');
    for(var record in list){
      ATM atm = new ATM();
      atm.Adress = record['Adress'];
      atm.Adresse = record['Adresse'];
      atm.Agen = record['Agen'];
      atm.Quoi = record['Quoi'];
      atm.Wat = record['Wat'];
      atm.What = record['What'];
      atm.Coord = new List();
      atm.Coord.add(record['Lat']);
      atm.Coord.add(record['Long']);
      atmlist.add(atm);
    }

    await addMarkers();
    //await database.close();

  }

  insertIntoTable() async {
    await database.transaction((txn) async {
      for(ATM atm in atmlist){
        print(atm.Coord.toString());
        int id = await txn.rawInsert(
            'INSERT INTO atms(Adresse, Adress, Agen, Quoi, Wat, What, Lat, Long) VALUES(?, ?, ?, ?, ?, ?, ?, ?)',
            [atm.Adresse,atm.Adress,atm.Agen,atm.Quoi,atm.Wat,atm.What,atm.Coord[0].toString(),atm.Coord[1].toString()]);
        print(id);
      }

    });

  }

  refillTable() async{
    print('test');
    var databasesPath = database.path;
    String path = join(databasesPath, "atm.db");
    await deleteDatabase(path);
    await checkDB();
  }


}