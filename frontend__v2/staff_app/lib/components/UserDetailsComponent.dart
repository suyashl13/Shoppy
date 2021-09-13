import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserDetailsComponent extends StatelessWidget {
  Map userDetails;
  UserDetailsComponent(this.userDetails);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              children: [
                ...userDetails.keys.map((key) => TableRow(children: [
                      Text(
                        key,
                        textScaleFactor: 1.1,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        userDetails[key],
                        textScaleFactor: 1.1,
                        style: TextStyle(color: Colors.white),
                      )
                    ]))
              ],
            )
          ],
        ),
      ),
    );
  }
}
