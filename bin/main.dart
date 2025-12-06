// all this main function is going to do
import 'package:main/server/server.dart';

void main() async {
  final httpServer = await generateServerConnection(
    productionHandler,
    8054,
    "0.0.0.0",
  );

  print(httpServer.connectionsInfo());
}
