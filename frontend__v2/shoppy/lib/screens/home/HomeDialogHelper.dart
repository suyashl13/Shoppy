import 'package:flutter/material.dart';
import 'package:shoppy/FirebaseAuthWrapper.dart';
import 'package:shoppy/helpers/BackendAuthHelper.dart';
import 'package:shoppy/screens/static/UpdateProfilePage.dart';
import 'package:shoppy/services/FirebaseAuthService.dart';

class HomeDialogHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    List listTileItems = [
      {
        'icon' : Icon(Icons.person_outline),
        'title': 'Edit Profile', 
        'callback': () async {
          Navigator.push(context, MaterialPageRoute(builder: (_)=> UpdateProfilePage()));
        }},
      {
        'icon' : Icon(Icons.logout_outlined),
        'title': 'Logout', 
        'callback': () async {
          AuthService().signOut();
          BackendAuthHelper().logoutAtBackend((_){}, (_){});
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FirebasebaseAuthWrapper() ));
        }}
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...listTileItems.map((e) => ListTile(
          leading: e['icon'],
          title: Text(e['title']),
          onTap: e['callback'],
        ))
      ],
    );
  }
}
