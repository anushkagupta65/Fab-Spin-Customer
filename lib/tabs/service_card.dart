import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgUrl;
  final VoidCallback onClick;
  const ServiceCard({
    super.key, required this.title, required this.subtitle, required this.imgUrl, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Recommended',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '105 mins',
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(5)),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 50,
                              width: 200,
                              child: Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.justify)),
                          Text('\u2022 Hybrid Ceramic Coat', style: TextStyle(color: Colors.grey),),
                          Text('\u2022 High Pressure Wash', style: TextStyle(color: Colors.grey),),
                          Text('\u2022 Shampoo Cleaning', style: TextStyle(color: Colors.grey),),
                          SizedBox(height: 15,),
                          // Container(
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Text('+9 More >', style: TextStyle(color: Colors.blue),),
                          //   ),
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(20)
                          //   ),
                          // ),
                          SizedBox(height: 10,),
                          // Row(
                          //   children: [
                          //     Text('\u{20B9}${832}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                          //     SizedBox(width: 5,),
                          //     Text('\u{20B9}${499}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
                          //     SizedBox(width: 5,),
                          //     Text('40% OFF', style: TextStyle(color: Colors.green, ),),
                          //   ],
                          // )

                          InkWell(
                            onTap: onClick,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black)),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text('Schedule Pickup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: Stack(
                          clipBehavior: Clip.none, children: [
                            Image.network(
                              imgUrl,
                              height: 150,
                              width: 130,
                            ),
                          // Container(
                          //   height: 150,
                          //   width: 130,
                          //
                          //   decoration: BoxDecoration(
                          //       color: Colors.grey,
                          //       borderRadius: BorderRadius.circular(15)
                          //   ),
                          // ),

                          Positioned(
                            left: 0,
                            right: 1,
                            top: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(10)),

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('With Underbody', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   left: 40,
                          //   top: 130,
                          //
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //         color: Colors.black,
                          //         borderRadius: BorderRadius.circular(10)),
                          //
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(12),
                          //       child: Text('ADD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                          //           color: Colors.white),),
                          //     ),
                          //   ),
                          // )
                        ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
