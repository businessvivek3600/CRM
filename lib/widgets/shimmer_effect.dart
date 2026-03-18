import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


Widget buildShimmerEffect({int length = 3}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[200]!,
    highlightColor: Colors.grey[50]!,
    child: ListView.builder( // Changed from Column to ListView.builder
      shrinkWrap: true, // Allows it to work inside constrained spaces
      physics: const NeverScrollableScrollPhysics(), // Parent handles scrolling
      itemCount: length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 120, height: 14, color: Colors.white),
                  Container(width: 60, height: 14, color: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              Container(width: 180, height: 12, color: Colors.white),
              const Divider(height: 24),
              Row(
                children: [
                  Container(width: 80, height: 20, color: Colors.white),
                  const Spacer(),
                  Container(width: 100, height: 12, color: Colors.white),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}