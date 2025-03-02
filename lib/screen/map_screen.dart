import 'package:aisits_mobileApp/service/notification_service.dart';

import '../service/json_service_provider.dart';
import '../model/ship_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../service/ship_provider.dart';
import '../service/ship_service.dart';
import '../widget/polygon_widget.dart';
import '../widget/custom_drawer.dart';
import '../widget/ship_detail_dialog.dart';  // Add this import at the top

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin {
  late final ShipService _shipService;
  late final MapController _mapController;
  bool _keepAlive = true;
  bool _isInitialized = false;
  
  @override
  bool get wantKeepAlive => _keepAlive;
  
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeServices();
  }
  
  @override
  void dispose() {
    if (!_keepAlive) {
      _mapController.dispose();
    }
    super.dispose();
  }
  Future<void> _initializeServices() async {
    if (_isInitialized) return;
  
    final jsonProvider = Provider.of<JsonServiceProvider>(context, listen: false);
    if (!jsonProvider.isLoaded) {
      Navigator.pushReplacementNamed(context, '/splash');
      return;
    }
  
    final shipProvider = Provider.of<ShipProvider>(context, listen: false);
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    shipProvider.onMarkerTap = _showShipDetails; 
    
    if (!shipProvider.isInitialized) {
      await shipProvider.initialize();
    }

    _shipService = ShipService(
      url: 'ws://146.190.89.97:6767',
      token: 'labramsjosgandoss',
      notificationService: notificationService,  // Add notification service
      onMarkerTap: _showShipDetails,
    );
  
    if (!_isInitialized) {
      await _shipService.loadShipData();
      _isInitialized = true;
    }
  
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _shipService.listenToShipDataStream((ShipData data) {
          if (!mounted) return;
          Provider.of<ShipProvider>(context, listen: false).addShip(data);
        });
      });
    }
  }
  void _showShipDetails(ShipData shipData) {
    if (!mounted) return;
    
    print("Showing details for ship: ${shipData.name ?? 'Unknown'} (${shipData.id})");
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => ShipDetailDialog(shipData: shipData),
    ).then((_) => print("Dialog closed"));
  }
  // Remove _buildDetailRow method as it's now in ShipDetailDialog
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        actions: [
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: const CustomDrawer(),
      body: Consumer<ShipProvider>(
        builder: (context, shipProvider, child) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(-7.257472, 112.752088),
                minZoom: 8.0,
                maxZoom: 14.0,
                onTap: (_, __) {
                  print("Map tapped");
                },
                interactiveFlags: InteractiveFlag.all,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                PolygonLayer(polygons: getPolygons()),
                MarkerLayer(
                  markers: shipProvider.markers.values.toList(),
                  rotate: true,  // Add this line
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "zoomInButton",
            onPressed: () {
              _mapController.move(
                  _mapController.center, _mapController.zoom + 1);
            },
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "zoomOutButton",
            onPressed: () {
              _mapController.move(
                  _mapController.center, _mapController.zoom - 1);
            },
            child: const Icon(Icons.zoom_out),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
          
        
      
    
