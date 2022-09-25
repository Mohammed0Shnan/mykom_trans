import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300.withOpacity(0.8),
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
        margin:
        EdgeInsets.symmetric(horizontal: 8),
        child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.9,
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
                          blurRadius: 3,
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
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    color: Colors.white,
                                    height: 20,
                                  )),
                                  Expanded(
                                      child: Container(
                                    color: Colors.white,
                                    height: 20,
                                  ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    color: Colors.white,
                                    height: 10,
                                  )),
                                  Container(
                                    color: Colors.white,
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                                flex: 3,
                                child: Container(
                                  color: Colors.white,
                                  height: 20,
                                )),
                            Spacer(),
                            Flexible(
                              flex: 2,
                              child: Container(
                                height: 20,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
