import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmerGridWidget extends StatelessWidget {

  ProductShimmerGridWidget();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300.withOpacity(0.8),
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: GridView.count(
        shrinkWrap: true,
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
          children: List.generate(
            4,
                (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 4,
                        offset: Offset(0, 5))
                  ]),
              child: Column(
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration:
                      BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                        )
                      ]),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child:Container(
                        height: 10,
                        width: double.infinity,
                        color: Colors.white,
                      )
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
