import 'package:dashboard/core/sample_api/api_method.dart';
import 'package:dashboard/core/sample_api/api_service.dart';
import 'package:dashboard/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class BookingDataSource extends DataGridSource {
  BookingDataSource(this.bookings) {
    _buildDataRows();
  }

  final List<Booking> bookings;
  List<DataGridRow> _dataGridRows = [];

  void _buildDataRows() {
    _dataGridRows = bookings.map<DataGridRow>((booking) {
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'apartment',
            value: booking.relationships.apartment.attributes.title,
          ),
          DataGridCell<String>(
            columnName: 'tenant',
            value: booking.relationships.tenant.attributes.fullName,
          ),
          DataGridCell<String>(
            columnName: 'landlord',
            value: booking.relationships.landlord.attributes.fullName,
          ),
          DataGridCell<String>(
            columnName: 'dates',
            value: '${booking.attributes.startDate} - ${booking.attributes.endDate}',
          ),
          DataGridCell<String>(
            columnName: 'nights',
            value: booking.attributes.nightsCount.toString(),
          ),
          DataGridCell<String>(
            columnName: 'price',
            value: booking.attributes.totalPriceFormatted,
          ),
          DataGridCell<String>(
            columnName: 'status',
            value: booking.attributes.status,
          ),
          DataGridCell<String>(
            columnName: 'created',
            value: booking.attributes.createdAtHuman,
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  int get rowCount => bookings.length;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: [
        // Apartment Title
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[0].value,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Tenant Name
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[1].value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Landlord Name
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[2].value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Dates
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[3].value,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Nights Count
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${row.getCells()[4].value} nights',
              style: const TextStyle(
                color: Colors.purple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Price
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[5].value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        // Status
        Container(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(row.getCells()[6].value).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _getStatusText(row.getCells()[6].value),
              style: TextStyle(
                color: _getStatusColor(row.getCells()[6].value),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Created At
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[7].value,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  void updateDataSource(List<Booking> newBookings) {
    bookings.clear();
    bookings.addAll(newBookings);
    _buildDataRows();
    notifyListeners();
  }
}

class BookingsManagementPage extends StatefulWidget {
  const BookingsManagementPage({super.key});

  @override
  State<BookingsManagementPage> createState() => _BookingsManagementPageState();
}

class _BookingsManagementPageState extends State<BookingsManagementPage> {
  List<Booking> bookingsList = [];
  bool isLoading = true;
  int totalBookings = 0;
  int approvedBookings = 0;
  int pendingBookings = 0;
  int completedBookings = 0;
  int cancelledBookings = 0;

  late BookingDataSource _bookingDataSource;

  Future<void> getAllBookings() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final result = await SimpleApiService.instance.makeRequest(
      method: ApiMethod.get,
      endpoint: "bookings",
    );

    result.fold(
      (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
          setState(() {
            isLoading = false;
          });
        }
      },
      (data) {
        if (mounted) {
          setState(() {
            // Safely parse bookings data with null checking
            final dataList = data['data'];
            if (dataList is List && dataList.isNotEmpty) {
              bookingsList = List<Booking>.from(
                dataList.map((item) => Booking.fromJson(item)),
              );
            } else {
              bookingsList = [];
            }

            _bookingDataSource.updateDataSource(bookingsList);

            // Calculate stats
            _calculateStats();

            isLoading = false;
          });
        }
      },
    );
  }

  void _calculateStats() {
    totalBookings = bookingsList.length;
    approvedBookings = bookingsList.where((booking) => booking.attributes.status.toLowerCase() == 'approved').length;
    pendingBookings = bookingsList.where((booking) => booking.attributes.status.toLowerCase() == 'pending').length;
    completedBookings = bookingsList.where((booking) => booking.attributes.status.toLowerCase() == 'completed').length;
    cancelledBookings = bookingsList.where((booking) => booking.attributes.status.toLowerCase() == 'cancelled').length;
  }

  @override
  void initState() {
    super.initState();
    _bookingDataSource = BookingDataSource(bookingsList);
    getAllBookings();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bookings Management',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          // Statistics Cards
          if (!isLoading && bookingsList.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Bookings',
                    totalBookings.toString(),
                    Icons.book,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatCard(
                    'Approved',
                    approvedBookings.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    pendingBookings.toString(),
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatCard(
                    'Completed',
                    completedBookings.toString(),
                    Icons.done_all,
                    Colors.blue,
                  ),
                ),
              ],
            ),

          if (!isLoading && bookingsList.isNotEmpty)
            const SizedBox(height: 30),

          // Bookings Table
          SizedBox(
            height: 600,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (bookingsList.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'No bookings found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: SfDataGridTheme(
                        data: SfDataGridThemeData(
                          headerColor: Colors.blue.shade50,
                          rowHoverColor: Colors.blue.shade50,
                        ),
                        child: SfDataGrid(
                          source: _bookingDataSource,
                          columns: [
                            GridColumn(
                              columnName: 'apartment',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Apartment'),
                              ),
                            ),
                            GridColumn(
                              columnName: 'tenant',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Tenant'),
                              ),
                            ),
                            GridColumn(
                              columnName: 'landlord',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Landlord'),
                              ),
                            ),
                            GridColumn(
                              columnName: 'dates',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Dates'),
                              ),
                              width: 180,
                            ),
                            GridColumn(
                              columnName: 'nights',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Nights'),
                              ),
                              width: 80,
                            ),
                            GridColumn(
                              columnName: 'price',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Price'),
                              ),
                              width: 120,
                            ),
                            GridColumn(
                              columnName: 'status',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Status'),
                              ),
                              width: 100,
                            ),
                            GridColumn(
                              columnName: 'created',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Created'),
                              ),
                              width: 120,
                            ),
                          ],
                          columnWidthMode: ColumnWidthMode.fill,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          allowSorting: true,
                          allowMultiColumnSorting: false,
                          allowTriStateSorting: false,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
