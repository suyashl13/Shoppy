import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/helpers/BackendCartsHelper.dart';

// ignore: must_be_immutable
class OrderDialogHelper extends StatelessWidget {
  late int cartId;
  bool isCanceled, isVerified;

  OrderDialogHelper(
      {required this.cartId,
      required this.isCanceled,
      required this.isVerified});

  @override
  Widget build(BuildContext context) {
    List listTileItems = [
      {
        'icon': Icon(Icons.close),
        'title': 'Cancel Order',
        'subtitle': "Cancel order.",
        'callback': () async {
          if (isCanceled) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Already cancelled.")));
            Navigator.pop(context);
            return;
          } if (isVerified) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Already Verified.")));
            Navigator.pop(context);
            return;
          }
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Alert"),
              content: Text("Are you sure want to cancel order"),
              actions: [
                TextButton(
                    onPressed: () async {
                      await BackendCartsHelper().cancelOrder(cartId, (_) async {
                        return await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text("Alert"),
                                  content: Text("Cart cancelled successfully."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please refresh to see updated cart list.")));
                                        },
                                        child: Text("Ok"))
                                  ],
                                ));
                      }, (err) async {
                        return await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(err.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please refresh to see updated cart list.")));
                                        },
                                        child: Text("Ok"))
                                  ],
                                ));
                      });
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("No")),
              ],
            ),
          );
        }
      },
      {
        'icon': Icon(Icons.verified_outlined),
        'title': 'Verify order',
        'subtitle': "Veriffy the order only if you recieved it.",
        'callback': () async {
          if (isCanceled) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Already cancelled.")));
            Navigator.pop(context);
            return;
          } if (isVerified) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Already Verified.")));
            Navigator.pop(context);
            return;
          }
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Alert"),
              content: Text("Did you recived the product ?"),
              actions: [
                TextButton(
                    onPressed: () async {
                      await BackendCartsHelper().verifyOrder(cartId, (_) async {
                        return await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text("Alert"),
                                  content: Text("Cart verfied successfully."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please refresh to see updated cart list.")));
                                        },
                                        child: Text("Ok"))
                                  ],
                                ));
                      }, (err) async {
                        return await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(err.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please refresh to see updated cart list.")));
                                        },
                                        child: Text("Ok"))
                                  ],
                                ));
                      });
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("No")),
              ],
            ),
          );
        }
      }
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...listTileItems.map((e) => ListTile(
              leading: e['icon'],
              title: Text(e['title']),
              subtitle: Text(e['subtitle']),
              onTap: e['callback'],
            ))
      ],
    );
  }
}
