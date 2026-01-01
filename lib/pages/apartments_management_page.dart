import 'package:dashboard/core/sample_api/api_method.dart';
import 'package:dashboard/core/sample_api/api_service.dart';
import 'package:dashboard/models/apartment.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../widgets/stat_card.dart';

class ApartmentDataSource extends DataGridSource {
  ApartmentDataSource(
    this.apartments,
    this.onViewDetails,
    this.onEdit,
    this.onDelete, {
    this.totalItems = 0,
    this.onPageChange,
  }) {
    _buildDataRows();
  }

  final List<Apartment> apartments;
  int totalItems;
  final Function(String) onViewDetails;
  final Function(String) onEdit;
  final Function(String) onDelete;
  final Function(int)? onPageChange;
  List<DataGridRow> _dataGridRows = [];

  void _buildDataRows() {
    _dataGridRows = apartments.map<DataGridRow>((apartment) {
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'name',
            value: apartment.attributes.title.isNotEmpty
                ? apartment.attributes.title
                : 'N/A',
          ),
          DataGridCell<String>(
            columnName: 'location',
            value: apartment.attributes.location.fullAddress.isNotEmpty
                ? apartment.attributes.location.fullAddress
                : 'N/A',
          ),
          DataGridCell<String>(
            columnName: 'area',
            value:
                '${apartment.attributes.specs.area > 0 ? apartment.attributes.specs.area : 0}',
          ),
          DataGridCell<String>(
            columnName: 'price',
            value: apartment.attributes.formattedPrice.isNotEmpty
                ? apartment.attributes.formattedPrice
                : 'N/A',
          ),
          DataGridCell<String>(
            columnName: 'rooms',
            value:
                '${apartment.attributes.specs.rooms > 0 ? apartment.attributes.specs.rooms : 0}',
          ),
          DataGridCell<String>(
            columnName: 'floor',
            value:
                '${apartment.attributes.specs.floor >= 0 ? apartment.attributes.specs.floor : 0}',
          ),
          DataGridCell<String>(
            columnName: 'features',
            value: apartment.attributes.features.isNotEmpty
                ? apartment.attributes.features.join(', ')
                : 'No features',
          ),
          DataGridCell<String>(columnName: 'actions', value: apartment.id),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  int get rowCount => totalItems; // Total number of items across all pages

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: [
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
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  row.getCells()[1].value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text('${row.getCells()[2].value} m²'),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[3].value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${row.getCells()[4].value} rooms',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text('Floor ${row.getCells()[5].value}'),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[6].value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete Apartment',
                onPressed: () => onDelete(row.getCells()[7].value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void updateDataSource(List<Apartment> newApartments, {int? totalItems}) {
    apartments.clear();
    apartments.addAll(newApartments);
    if (totalItems != null) {
      this.totalItems = totalItems;
    }
    _buildDataRows();
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // Convert from 0-based index to 1-based page number
    final pageNumber = newPageIndex + 1;

    // Call the callback if provided
    if (onPageChange != null) {
      await onPageChange!(pageNumber);
    }

    return true;
  }
}

class ApartmentsManagementPage extends StatefulWidget {
  const ApartmentsManagementPage({super.key});

  @override
  State<ApartmentsManagementPage> createState() =>
      _ApartmentsManagementPageState();
}

class _ApartmentsManagementPageState extends State<ApartmentsManagementPage> {
  List<Apartment> apartmentsList = [];
  bool isLoading = true;
  int totalApartments = 0;
  int availableApartments = 0;
  int occupiedApartments = 0;
  int maintenanceApartments = 0;

  // Pagination variables
  int currentPage = 1;
  int lastPage = 1;
  int perPage = 10;
  int totalItems = 0;
  bool isLoadingPage = false;

  late ApartmentDataSource _apartmentDataSource;

  Future<void> getAllApartments({int page = 1, int perPage = 10}) async {
    if (mounted) {
      setState(() {
        if (page == 1) {
          isLoading = true;
        } else {
          isLoadingPage = true;
        }
      });
    }

    final result = await SimpleApiService.instance.makeRequest(
      method: ApiMethod.get,
      endpoint: "apartments",
      queryParams: {'page': page.toString(), 'per_page': perPage.toString()},
    );

    result.fold(
      (error) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
          setState(() {
            isLoading = false;
            isLoadingPage = false;
          });
        }
      },
      (data) {
        final apartmentsData = data;
        if (mounted) {
          setState(() {
            // Safely parse apartments data with null checking
            final dataList = apartmentsData['data'];
            if (dataList is List && dataList.isNotEmpty) {
              apartmentsList = List<Apartment>.from(
                dataList
                    .map((item) {
                      try {
                        return Apartment.fromJson(item);
                      } catch (e) {
                        // Log error and skip invalid items
                        return null;
                      }
                    })
                    .where((item) => item != null)
                    .cast<Apartment>(),
              );
            } else {
              apartmentsList = [];
            }

            // Parse pagination data
            final meta = apartmentsData['meta'];
            if (meta != null) {
              currentPage = meta['current_page'] ?? 1;
              lastPage = meta['last_page'] ?? 1;
              perPage = meta['per_page'] ?? 10;
              totalItems = meta['total'] ?? 0;
            }

            _apartmentDataSource.updateDataSource(
              apartmentsList,
              totalItems: totalItems,
            );

            // Calculate stats only on first page load
            if (page == 1) {
              _calculateStats();
            }

            isLoading = false;
            isLoadingPage = false;
          });
        }
      },
    );
  }

  void _calculateStats() {
    totalApartments = apartmentsList.length;
    // Since the API doesn't provide status, we'll categorize by room count
    availableApartments = apartmentsList
        .where((apt) => apt.attributes.specs.rooms >= 3)
        .length; // Consider 3+ rooms as "premium"
    occupiedApartments = apartmentsList
        .where((apt) => apt.attributes.specs.rooms == 2)
        .length; // 2 rooms as "standard"
    maintenanceApartments = apartmentsList
        .where((apt) => apt.attributes.specs.rooms <= 1)
        .length; // 1 room or less as "basic"
  }

  @override
  void initState() {
    super.initState();
    _apartmentDataSource = ApartmentDataSource(
      apartmentsList,
      _viewApartmentDetails,
      _editApartment,
      _deleteApartment,
      totalItems: totalItems,
      onPageChange: _handlePageChange,
    );
    getAllApartments();
  }

  Future<void> _viewApartmentDetails(String apartmentId) async {
    // TODO: Navigate to apartment details page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View details for apartment $apartmentId')),
    );
  }

  Future<void> _editApartment(String apartmentId) async {
    // TODO: Navigate to edit apartment page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit apartment $apartmentId')));
  }

  Future<void> _deleteApartment(String apartmentId) async {
    final result = await SimpleApiService.instance.makeRequest(
      method: ApiMethod.delete,
      endpoint: "apartments/$apartmentId",
    );

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete apartment: $error')),
        );
      },
      (data) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Apartment deleted successfully')),
        );
        // Refresh the apartments list
        getAllApartments(page: currentPage, perPage: perPage);
      },
    );
  }

  Future<void> _handlePageChange(int pageNumber) async {
    await getAllApartments(page: pageNumber, perPage: perPage);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Apartments Management',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          // Pagination Controls
          if (!isLoading && apartmentsList.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
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
                  // Page info and rows per page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Page $currentPage of $lastPage • Total: $totalItems apartments',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                      Row(
                        children: [
                          const Text('Show: ', style: TextStyle(fontSize: 14)),
                          DropdownButton<int>(
                            value: perPage,
                            items: const [
                              DropdownMenuItem(value: 5, child: Text('5')),
                              DropdownMenuItem(value: 10, child: Text('10')),
                              DropdownMenuItem(value: 15, child: Text('15')),
                              DropdownMenuItem(value: 20, child: Text('20')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  perPage = value;
                                });
                                getAllApartments(page: 1, perPage: value);
                              }
                            },
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: currentPage > 1 && !isLoadingPage
                            ? () => _handlePageChange(1)
                            : null,
                        icon: const Icon(Icons.first_page),
                        tooltip: 'First Page',
                        color: currentPage > 1 ? Colors.blue : Colors.grey,
                      ),
                      IconButton(
                        onPressed: currentPage > 1 && !isLoadingPage
                            ? () => _handlePageChange(currentPage - 1)
                            : null,
                        icon: const Icon(Icons.chevron_left),
                        tooltip: 'Previous Page',
                        color: currentPage > 1 ? Colors.blue : Colors.grey,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Page $currentPage',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: currentPage < lastPage && !isLoadingPage
                            ? () => _handlePageChange(currentPage + 1)
                            : null,
                        icon: const Icon(Icons.chevron_right),
                        tooltip: 'Next Page',
                        color: currentPage < lastPage
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      IconButton(
                        onPressed: currentPage < lastPage && !isLoadingPage
                            ? () => _handlePageChange(lastPage)
                            : null,
                        icon: const Icon(Icons.last_page),
                        tooltip: 'Last Page',
                        color: currentPage < lastPage
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ],
                  ),

                  if (isLoadingPage)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LinearProgressIndicator(),
                    ),
                ],
              ),
            ),

          if (!isLoading && apartmentsList.isNotEmpty)
            const SizedBox(height: 20),

          // Apartments Table
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
                  else if (apartmentsList.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'No apartments found',
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
                          source: _apartmentDataSource,
                          columns: [
                            GridColumn(
                              columnName: 'name',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Title'),
                              ),
                            ),
                            GridColumn(
                              columnName: 'location',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Location'),
                              ),
                            ),
                            GridColumn(
                              columnName: 'area',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Area (m²)'),
                              ),
                              width: 100,
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
                              columnName: 'rooms',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Rooms'),
                              ),
                              width: 80,
                            ),
                            GridColumn(
                              columnName: 'floor',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Floor'),
                              ),
                              width: 70,
                            ),
                            GridColumn(
                              columnName: 'features',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Features'),
                              ),
                              width: 150,
                            ),
                            GridColumn(
                              columnName: 'actions',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Actions'),
                              ),
                              width: 180,
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

  String _calculateAverageArea() {
    if (apartmentsList.isEmpty) return '0';
    final totalArea = apartmentsList
        .map((apt) => apt.attributes.specs.area)
        .reduce((a, b) => a + b);
    return (totalArea / apartmentsList.length).round().toString();
  }

  String _calculateAveragePrice() {
    if (apartmentsList.isEmpty) return '0';
    final totalPrice = apartmentsList
        .map((apt) => apt.attributes.price)
        .reduce((a, b) => a + b);
    return (totalPrice / apartmentsList.length).round().toString();
  }
}
