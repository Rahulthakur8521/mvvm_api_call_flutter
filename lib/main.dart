
import 'package:flutter/material.dart';
import 'package:mvvm_flutter/view/home_screen.dart';
import 'package:mvvm_flutter/view_model/photo_view_model.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PhotoApiProvider(),),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PhotoPage(),
      ),

    );
  }
}


