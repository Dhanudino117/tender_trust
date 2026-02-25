// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/booking_model.dart';
import '../../widgets/booking_card.dart';
import 'active_session.dart';
import 'write_review.dart';

const Color _primaryColor = Color(0xFFFF7E67);
const Color _secondaryColor = Color(0xFF56C6A9);
const Color _bgColor = Color(0xFFFFF9F0);
const Color _textPrimary = Color(0xFF2D3047);
const Color _textSecondary = Color(0xFF6B7280);

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              'My Bookings',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: _textSecondary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              indicator: BoxDecoration(
                color: _primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Pending'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList([
                  BookingStatus.ongoing,
                  BookingStatus.accepted,
                ]),
                _buildBookingList([BookingStatus.pending]),
                _buildBookingList([BookingStatus.completed]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingStatus> statuses) {
    final bookings = mockBookings
        .where((b) => statuses.contains(b.status))
        .toList();
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 56,
              color: _textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            const Text(
              'No bookings here',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return BookingCard(
          booking: booking,
          onTap: () {
            if (booking.status == BookingStatus.ongoing) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ActiveSessionPage(booking: booking),
                ),
              );
            } else if (booking.status == BookingStatus.completed) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WriteReviewPage(booking: booking),
                ),
              );
            }
          },
        );
      },
    );
  }
}
