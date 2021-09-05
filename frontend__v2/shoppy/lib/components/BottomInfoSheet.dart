import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomInfoSheet extends StatelessWidget {
  late Map orderDetails;
  BottomInfoSheet(this.orderDetails);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Table(
              children: [
                ...orderDetails.keys
                .map((e) => TableRow(children: [
                      Text(
                        "$e",
                        textScaleFactor: 1.2,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "${orderDetails[e]}",
                        textScaleFactor: 1.2,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white),
                      ),
                    ]))
                .toList(),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Hide Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
