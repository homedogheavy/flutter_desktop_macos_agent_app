import 'package:flutter/material.dart';
import 'package:flutter_desktop_macos_agent_app/home.dart';
import 'package:path/path.dart' as p;
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SystemTray _systemTray = SystemTray();

  @override
  void initState() {
    super.initState();
    initSystemTray();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initSystemTray() async {
    final path = p.joinAll(['AppIcon']);

    await _systemTray.initSystemTray("system tray",
        iconPath: path, toolTip: "How to use system tray with Flutter");

    await _systemTray.setContextMenu(
      [
        MenuItem(
          label: 'Show',
          onClicked: () {
            windowManager.show();
          },
        ),
        MenuItem(
          label: 'Hide',
          onClicked: () {
            windowManager.hide();
          },
        ),
        MenuSeparator(),
        SubMenu(
          label: "SubMenu",
          children: [
            MenuItem(
              label: 'show',
              enabled: false,
              onClicked: () {
                windowManager.show();
              },
            ),
            MenuItem(
              label: 'hide',
              onClicked: () {
                windowManager.hide();
              },
            ),
          ],
        ),
        MenuSeparator(),
        MenuItem(
          label: 'Exit',
          onClicked: () {
            windowManager.terminate();
          },
        ),
      ],
    );

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      print("eventName: $eventName");
      if (eventName == "leftMouseUp") {
        windowManager.show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
