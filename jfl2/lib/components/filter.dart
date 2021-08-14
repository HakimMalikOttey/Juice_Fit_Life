import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jfl2/components/single_line_textfield.dart';
import 'package:jfl2/data/filter_actions.dart';
import 'package:jfl2/data/user_data.dart';
import 'package:provider/provider.dart';

class Filter extends StatefulWidget {
  final TextEditingController searchController;
  final  Function(Map<dynamic, dynamic>?)? queryAction;
  final VoidCallback? submitAction;
  final bool? show;
  Map? value;
  Filter(
      {required this.searchController,
      required this.queryAction,
      this.submitAction,
      this.show,
      this.value});

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ValueListenableBuilder(
          valueListenable:
              Provider.of<UserData>(context, listen: false).BatchOperation,
          builder: (context, data, snapshot) {
            return Container(
              width: MediaQuery.of(context).size.width,
              // height: 70.0,
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13.0),
                        child: GestureDetector(
                          onTap: data == false ? widget.submitAction : () {},
                          child: Container(
                            // height: MediaQuery.of(context).size.height,
                            color: Colors.white,
                            child: Center(
                                child: Icon(Icons.search, color: Colors.black)),
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 250.0,
                      height: 100.0,
                      child: Center(
                        child: CustomTextBox(
                          // show: show == null || show == true ? true : show,
                          controller: widget.searchController,
                          hintText: "Search...",
                          onChanged: (String) {},
                          active: data == false ? true : false,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: widget.value != null ? 2 : 0,
                    child: widget.value != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                            child: Container(
                                // height: MediaQuery.of(context).size.height,
                                color: Colors.white,
                                // height: 90.0,
                                child: data == false
                                    ? Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: DropdownButton(
                                            dropdownColor: Colors.white,
                                            isExpanded: true,
                                            value: widget.value,
                                            // style:
                                            //     Theme.of(context).textTheme.headline2,
                                            icon: Icon(Icons.arrow_drop_down),
                                            underline: Container(),
                                            onChanged: widget.queryAction,
                                            items: filters
                                                .map<DropdownMenuItem<Map>>(
                                                    (value) {
                                              return DropdownMenuItem<Map>(
                                                value: value,
                                                child: Row(
                                                  children: [
                                                    Text(value["name"],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      )
                                    : Container()),
                          )
                        : Container(),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
