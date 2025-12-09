// all this main function is going to do
import 'package:main/classes/production_handler.dart';
import 'package:main/utilities/utilities.dart';

void main() async {
  final httpServer = await generateServerConnection(
    ProductionHandler().handler,
    "0.0.0.0",
    8054,
  );

  print(httpServer.connectionsInfo());
}
