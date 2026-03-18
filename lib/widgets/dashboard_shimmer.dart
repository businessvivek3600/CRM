import 'package:crm/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Title shimmer
          _shimmerBox(height: 18, width: 180),

          const SizedBox(height: 16),

          /// Grid shimmer
          GridView.builder(
            shrinkWrap: true,
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (_, __) => _cardShimmer(),
          ),

          const SizedBox(height: 16),

          /// Pipeline card shimmer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _decoration(),
            child: Column(
              children: List.generate(
                4,
                    (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _shimmerBox(height: 14, width: 120),
                          _shimmerBox(height: 14, width: 60),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _shimmerBox(height: 8, width: double.infinity),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(height: 28, width: 28),
              _shimmerBox(height: 20, width: 40),
            ],
          ),
          const Spacer(),
          _shimmerBox(height: 12, width: 100),
        ],
      ),
    );
  }

  Widget _shimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: CRMColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  BoxDecoration _decoration() => BoxDecoration(
    color: CRMColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: CRMColors.border),
  );
}