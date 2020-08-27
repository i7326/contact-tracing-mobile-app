import 'package:flutter/material.dart';

class TilesWidget extends StatelessWidget {
  final Color color;
  final String status;
  const TilesWidget({@required this.color, @required this.status}) : assert(color != null) , assert(status != null);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(24.0),
        child: Material(
            color: color,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(12.0),
            shadowColor: Color(0x802196F3),
            child: Container(
              width: 1.7976931348623157e+308,
              height: 150.0,
              child: Container(
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  alignment: Alignment.topCenter,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Text(
                          "Infection Status",
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"),
                        ),
                        new Padding(
                          child: new Container(
                            child: new Text(
                              status,
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto"),
                            ),
                            padding: const EdgeInsets.all(0.0),
                            alignment: Alignment.topLeft,
                            width: 1.7976931348623157e+308,
                            height: 80.0,
                          ),
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 15.0, 14.0, 15.0),
                        )
                      ]),
                ),
                padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 1.0),
                alignment: Alignment.topCenter,
                width: 1.7976931348623157e+308,
                height: 1.7976931348623157e+308,
              ),
            )));
  }
}
