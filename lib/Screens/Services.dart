import 'package:flutter/material.dart';
import 'package:scroll_to_animate_tab/scroll_to_animate_tab.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('SERVICES'),
        ),
        body: ScrollToAnimateTab(
          activeTabDecoration: TabDecoration(
              textStyle: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(5)))),
          inActiveTabDecoration: TabDecoration(
              textStyle: const TextStyle(color: Colors.black),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: const BorderRadius.all(Radius.circular(5)))),
          tabs: [
            ScrollableList(
                label: "Shoe Cleaning",
                body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (_, index) => ListTile(
                    title: Text('List element ${index + 1}'),
                  ),
                )),
            ScrollableList(
                label: "Leather Cleaning",
                body: Column(
                  children: List.generate(
                      10,
                      (index) => ListTile(
                            title: Text('List element ${index + 1}'),
                          )),
                )),
            ScrollableList(
                label: "Garment Cleaning",
                body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (_, index) => ListTile(
                    title: Text('List element ${index + 1}'),
                  ),
                )),
            ScrollableList(
                label: "Bag Cleaning",
                body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (_, index) => ListTile(
                    title: Text('List element ${index + 1}'),
                  ),
                )),
            ScrollableList(
                
                label: "Sofa Cleaning",
                body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (_, index) => ListTile(
                    title: Text('List element ${index + 1}'),
                  ),
                )),
          ],
        ));
  }
}
