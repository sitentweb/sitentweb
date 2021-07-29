import 'package:flutter/material.dart';
import 'package:remark_app/components/shimmer/shimmer_this.dart';

class JobCardShimmer extends StatelessWidget {
  const JobCardShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    ShimmerThis(
                      child: Container(
                        width: size.width * 0.4,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                child: Row(
                  children: [
                    ShimmerThis(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    ShimmerThis(
                      child: Container(
                        width: size.width * 0.6,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  ShimmerThis(
                    child: Container(
                      width: size.width * 0.4,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ),
                  ),
                  Spacer(),
                  ShimmerThis(
                    child: Container(
                      width: size.width * 0.4,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ),
                  ),
                  Spacer()
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  ShimmerThis(
                    child: Container(
                      width: size.width * 0.4,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ),
                  ),
                  Spacer()
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  ShimmerThis(
                    child: Container(
                      width: size.width * 0.4,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ),
                  ),
                  Spacer(),
                  ShimmerThis(
                    child: Container(
                      width: size.width * 0.4,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  SizedBox(width: 10,),
                  ShimmerThis(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ShimmerThis(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ),
                  ),
                  Spacer(),
                  ShimmerThis(
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}