


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerEffect({int length = 3}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
      children: List.generate(length, (index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
            ),
            title: Container(
              width: double.infinity,
              height: 10,
              color: Colors.white,
            ),
            subtitle: Container(
              width: 100,
              height: 10,
              color: Colors.white,
            ),
            trailing: Container(
              width: 80,
              height: 20,
              color: Colors.white,
            ),
          ),
        );
      }),
    ),
  );
}