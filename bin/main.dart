// all this main function is going to do
import 'package:main/server/server.dart';

void main() async {
  await generateServerConnection(productionHandler, 8054, "localhost");
}
