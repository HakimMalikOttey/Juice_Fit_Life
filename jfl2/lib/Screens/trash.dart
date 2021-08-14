// List<Map> planbuttons = [
//   {
//     "icon": FontAwesomeIcons.check,
//     "name": "Plan Maker",
//     "color": Colors.pinkAccent,
//     "navigator": PlanEditorLaunch.id
//   },
//   {
//     "icon": FontAwesomeIcons.calendar,
//     "name": "Day Maker",
//     "color": Colors.red,
//     "navigator":DayEditorLaunch.id
//
//   },
//   {
//     "icon": FontAwesomeIcons.dumbbell,
//     "name": "Workout Maker",
//     "color":Colors.blue,
//     "navigator":WorkoutEditorLaunch.id
//   },
//   {
//     "icon": FontAwesomeIcons.coffee,
//     "name": "Meal Maker",
//     "color":Colors.orange,
//     "navigator": MealPlanEditorLaunch.id
//   },
// ];
// Positioned(
//   top: 0,
//   child: GestureDetector(
//     onTap:(){
//       setState(() {
//         // height += details.delta.dy;
//         if(height == 45.0){
//           barrier = WillPopScope(
//               onWillPop: (){
//                 setState(() {
//                   barrier = Container();
//                   height = 45.0;
//                 });
//                 return Future<bool>.value(false);
//               },
//               child: _animatedModalBarrier
//           );
//           _animationController.reset();
//           _animationController.forward();
//           height = 150.0;
//         }
//         else if(height == 150.0 ){
//           barrier = Container();
//           height = 45.0;
//         }
//         else{
//           barrier = Container();
//         }
//       });
//     },
//     child: Container(
//       decoration: BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage("assets/weights.jpg"),
//               fit: BoxFit.cover,
//               colorFilter: new ColorFilter.matrix(<double>[
//                 0.2126, 0.250, 0.070, 0, -55,
//                 0.2126, 0.250, 0.070, 0, -55,
//                 0.2126, 0.250, 0.070, 0, -55,
//                 0, 0, 0, 1, 0,
//               ])
//           ),),
//       width: MediaQuery.of(context).size.width,
//       height: height,
//       child: height != 45 ?  Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(top:8.0,left: 5.0,right: 5.0),
//               child: Container(
//                 child: GridView.builder(
//                   physics: ClampingScrollPhysics(),
//                     itemCount: planbuttons.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,crossAxisSpacing: 15.0),
//                     itemBuilder: (context, int){
//                       return GestureDetector(
//                         onTap: (){
//                           setState(() {
//                             _selectbuttoncolor = planbuttons[int]["color"];
//                             _selectbuttonicon = planbuttons[int]["icon"];
//                             _selectbuttontext = planbuttons[int]["name"];
//                             barrier = Container();
//                             height = 45.0;
//                           });
//                           _navigatorKey.currentState.pushNamed(planbuttons[int]["navigator"]);
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(100)),
//                             color: planbuttons[int]["color"],
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               FaIcon(planbuttons[int]["icon"],color: Colors.white,),
//                               Text(planbuttons[int]["name"],style: Theme.of(context).textTheme.headline1,textAlign: TextAlign.center ,)
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                 )
//               ),
//             ),
//           ),
//           Container(
//             height: 45.0,
//             color: _selectbuttoncolor ,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10.0),
//               child: Row(
//                 children: [
//                   FaIcon(_selectbuttonicon ,color: Colors.white),
//                   SizedBox(
//                     width: 30.0,
//                   ),
//                   Text(_selectbuttontext, style:Theme.of(context).textTheme.headline6 ),
//                   Icon(Icons.keyboard_arrow_up,color: Colors.white,)
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ): Container(
//         height: 45.0,
//         color: _selectbuttoncolor ,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 10.0),
//           child: Row(
//             children: [
//               FaIcon(_selectbuttonicon ,color: Colors.white),
//               SizedBox(
//                 width: 30.0,
//               ),
//               Text(_selectbuttontext, style:Theme.of(context).textTheme.headline6 ),
//               Icon(Icons.keyboard_arrow_down,color: Colors.white,)
//             ],
//           ),
//         ),
//       ),
//     ),
//   ),
// ),