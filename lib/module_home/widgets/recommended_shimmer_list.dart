import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecommendedProductsShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300.withOpacity(0.8),
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context,index){
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          height: 150,
          width: 110,
          color: Colors.white,
        );
      }),
    );
  }
}
