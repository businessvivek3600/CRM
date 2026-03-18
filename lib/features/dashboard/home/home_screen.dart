import 'dart:async';
import 'package:crm/store/app_store.dart';
import 'package:crm/utils/default_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../../store/lead_store.dart';
import '../../../../services/api_services.dart';
import '../../../widgets/dashboard_shimmer.dart';

/// --------------------
/// REFINED PROFESSIONAL PALETTE
/// --------------------
const Color crmPrimary = Color(0xFF0F172A); // Deep Navy
const Color crmAccent = Color(0xFF3B82F6); // Modern Blue
const Color crmBg = Color(0xFFF8FAFC); // Soft Slate Background
const Color crmSurface = Color(0xFFFFFFFF); // Pure White
const Color crmTextBold = Color(0xFF1E293B); // Slate 800
const Color crmTextMuted = Color(0xFF64748B); // Slate 500
const Color crmBorder = Color(0xFFE2E8F0); // Slate 200

Future<void> hitApiWithLocation(
    String userId, double latitude, double longitude) async {
  FormData formData = FormData.fromMap({
    'id': userId,
    'latitude': latitude,
    'longitude': longitude,
  });

  final (bool status, Map<String, dynamic> response, String? message) =
      await ApiService.uploadLocation(formData);

  if (status) {
    infoLog('Success: $message');
  } else {
    infoLog('API Error: $response');
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _requestLocationPermission();
    _scheduleLocationTask();
    afterBuildCreated(() => fetchCompanyInfo());
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: crmBg,
      body: Observer(
        builder: (context) {
          if (leadStore.loadingLeads) {
            return const DashboardShimmer();
          }

          return RefreshIndicator(
            onRefresh: () async => await leadStore.getDashboard(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Analytics Overview",
                      style: boldTextStyle(size: 18, color: crmTextBold)),
                  const SizedBox(height: 16),

                  /// --- STATS GRID ---
                  /// Space reduced by changing childAspectRatio to 1.6 and adjusting spacing
                  GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      _buildStatCard(
                          "Total Leads",
                          leadStore.firstBox.totalLeads.toString(),
                          Icons.layers_rounded,
                          Colors.indigo),
                      _buildStatCard(
                          "Converted",
                          leadStore.secondBox.totalConverted.toString(),
                          Icons.verified_rounded,
                          Colors.blueGrey),
                      _buildStatCard(
                          "New Leads",
                          leadStore.thirdBox.totalNewLeads.toString(),
                          Icons.auto_awesome_rounded,
                          Colors.orange),
                      _buildStatCard(
                          "Contacted",
                          leadStore.fourthBox.totalContactLeads.toString(),
                          Icons.headset_mic_rounded,
                          Colors.lightBlueAccent),
                    ],
                  ),

                  const SizedBox(
                      height: 16), // Tighter gap before the next card

                  /// --- LEADS OVERVIEW CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: _professionalDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                        height: 16, width: 3, color: crmAccent)
                                    .cornerRadiusWithClipRRect(2),
                                8.width,
                                Text("Leads Pipeline",
                                    style: boldTextStyle(
                                        color: crmTextBold, size: 16)),
                              ],
                            ),
                            const Icon(Icons.insights_rounded,
                                color: crmTextMuted, size: 20),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: leadStore.leadStatusDashboard.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final lead = leadStore.leadStatusDashboard[index];
                            final colorCode = lead.color.replaceFirst('#', '');
                            final progress = leadStore.firstBox.totalLeads > 0
                                ? lead.total / leadStore.firstBox.totalLeads
                                : 0.0;

                            return ProfessionalProgressItem(
                              label: lead.name,
                              value: progress,
                              count: lead.total,
                              color: Color(int.parse('0xFF$colorCode')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// --- UI HELPERS ---
  BoxDecoration _professionalDecoration() => BoxDecoration(
        color: crmSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: crmBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  Widget _buildStatCard(
      String label, String count, IconData icon, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _professionalDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 18),
              ),
              Text(count, style: boldTextStyle(size: 20, color: crmTextBold)),
            ],
          ),
          const Spacer(),
          Text(label, style: secondaryTextStyle(size: 12, color: crmTextMuted)),
        ],
      ),
    );
  }

  /// --- EXISTING LOGIC ---
  Future<void> fetchCompanyInfo() async => await leadStore.getDashboard();

  Future<void> _initializeData() async {
    await Future.wait([
      leadStore.getDashboard(),
      appStore.loadUserData(),
    ]);
  }

  Future<void> _requestLocationPermission() async {
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  void _scheduleLocationTask() {
    _locationTimer?.cancel();
    _locationTimer =
        Timer.periodic(const Duration(minutes: 10), (_) => getLocation());
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      // 1️⃣ Check if location service (GPS) is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        warningLog("Location service is disabled");

        // Optional: open location settings
        await Geolocator.openLocationSettings();
        return;
      }

      // 2️⃣ Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        warningLog("Location permission denied");
        return;
      }

      // 3️⃣ Get location
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4️⃣ Hit API
      await hitApiWithLocation(
        appStore.staffId,
        pos.latitude,
        pos.longitude,
      );
    } catch (e) {
      errorLog("Location error: $e");
    }
  }}

/// --------------------
/// PROFESSIONAL PROGRESS COMPONENT
/// --------------------
class ProfessionalProgressItem extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final int count;

  const ProfessionalProgressItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: primaryTextStyle(
                    size: 14, color: crmTextBold, weight: FontWeight.w500)),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "$count",
                      style: boldTextStyle(size: 14, color: crmTextBold)),
                  TextSpan(text: " leads", style: secondaryTextStyle(size: 12)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: crmBg,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
