import 'package:flutter/material.dart';
import 'camera/camera_manager.dart';
import 'confirm_page.dart';
import 'global.dart';

class IdScanPage extends StatefulWidget {
  const IdScanPage({super.key});

  @override
  State<IdScanPage> createState() => _IdScanPageState();
}

class _IdScanPageState extends State<IdScanPage> with WidgetsBindingObserver {
  late MobileCamera _mobileCamera;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _mobileCamera = MobileCamera(
        context: context,
        cbRefreshUi: refreshUI,
        cbIsMounted: isMounted,
        cbNavigation: navigation,
        scanType: ScanType.id);
    _mobileCamera.initState();
  }

  void navigation(dynamic result) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => ConfirmPage(
        scannedData: result,
      ),
    );
    routes.add(route);
    Navigator.push(
      context,
      route,
    ).then((value) => _mobileCamera.initCamera());
  }

  void refreshUI() {
    setState(() {});
  }

  bool isMounted() {
    return mounted;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mobileCamera.stopVideo();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_mobileCamera.controller == null ||
        !_mobileCamera.controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _mobileCamera.controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _mobileCamera.toggleCamera(0);
    }
  }

  Widget getButtons() {
    if (_mobileCamera.isDriverLicense) {
      return Row(children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _mobileCamera.isDriverLicense = true;
                _mobileCamera.mrzLines = null;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff323234),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFfe8e14),
                      width: 2,
                    ),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFfe8e14),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Driver License',
                    style: TextStyle(color: Color(0xFFfe8e14)),
                  )
                ]),
              ),
            )),
        GestureDetector(
            onTap: () {
              setState(() {
                _mobileCamera.isDriverLicense = false;
                _mobileCamera.barcodeResults = null;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff0C0C0C),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Passport',
                    style: TextStyle(color: Colors.white),
                  )
                ]),
              ),
            ))
      ]);
    } else {
      return Row(children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _mobileCamera.isDriverLicense = true;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff0C0C0C),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Driver License',
                    style: TextStyle(color: Colors.white),
                  )
                ]),
              ),
            )),
        GestureDetector(
            onTap: () {
              setState(() {
                _mobileCamera.isDriverLicense = false;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff323234),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFfe8e14),
                      width: 2,
                    ),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFfe8e14),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Passport',
                    style: TextStyle(color: Color(0xFFfe8e14)),
                  )
                ]),
              ),
            ))
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          routes.removeLast();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Scan Identity Documents',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                routes.removeLast();
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              if (_mobileCamera.controller != null &&
                  _mobileCamera.previewSize != null)
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 50,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Stack(
                      children: [
                        if (_mobileCamera.controller != null &&
                            _mobileCamera.previewSize != null)
                          SizedBox(
                              width: MediaQuery.of(context).size.width <
                                      MediaQuery.of(context).size.height
                                  ? _mobileCamera.previewSize!.height
                                  : _mobileCamera.previewSize!.width,
                              height: MediaQuery.of(context).size.width <
                                      MediaQuery.of(context).size.height
                                  ? _mobileCamera.previewSize!.width
                                  : _mobileCamera.previewSize!.height,
                              child: _mobileCamera.getPreview()),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          bottom: 0,
                          left: 0.0,
                          child: createOverlay(
                              _mobileCamera.barcodeResults,
                              _mobileCamera.mrzLines,
                              _mobileCamera.documentResults),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(bottom: 0, child: getButtons()),
            ],
          ),
        ));
  }
}
