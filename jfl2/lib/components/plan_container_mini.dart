import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanContainerMini extends StatelessWidget {
  final VoidCallback ontap;
  PlanContainerMini({required this.ontap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: InkWell(
        onTap: ontap,
        highlightColor: Colors.grey[850]?.withOpacity(0.3),
        child: Container(
          color: Theme.of(context).cardColor,
          height: MediaQuery.of(context).size.height,
          width: 250.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/weights.jpg"),
                            fit: BoxFit.fill)),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Expanded(
                    child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Plan Name",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        "Plan hook",
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
