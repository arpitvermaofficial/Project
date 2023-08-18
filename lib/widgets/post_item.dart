import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {

  final String title;

  PostItem(this.title, );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 200,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.lightBlueAccent
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           Image.network(title),
            const SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }
}