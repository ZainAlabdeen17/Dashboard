import 'package:dashboard/core/sample_api/api_method.dart';
import 'package:dashboard/core/sample_api/api_service.dart';
import 'package:dashboard/models/user.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../widgets/stat_card.dart';

class UserDataPagerDelegate extends DataPagerDelegate {
  UserDataPagerDelegate(this.onPageChanged, this.dataPagerController);

  final Function(int) onPageChanged;
  final DataPagerController dataPagerController;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    onPageChanged(newPageIndex + 1); // Convert to 1-based indexing
    // The controller will be updated in the parent widget after data loads
    return true;
  }

  bool canMoveToPage(int pageIndex) {
    return true; // Allow moving to any page
  }
}

class UserDataSource extends DataGridSource {
  UserDataSource(
    this.users,
    this.onVerify,
    this.onDelete, {
    this.totalItems = 0,
  }) {
    _buildDataRows();
  }

  final List<User> users;
  int totalItems;
  final Function(String) onVerify;
  final Function(String) onDelete;
  List<DataGridRow> _dataGridRows = [];

  void _buildDataRows() {
    _dataGridRows = users.map<DataGridRow>((user) {
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'image',
            value: user.attributes.avatarUrl,
          ),
          DataGridCell<String>(
            columnName: 'name',
            value: user.attributes.fullName,
          ),
          DataGridCell<String>(
            columnName: 'phone',
            value: user.attributes.phoneNumber,
          ),
          DataGridCell<String>(columnName: 'role', value: user.attributes.role),
          DataGridCell<String>(
            columnName: 'status',
            value: user.attributes.isVerified ? 'Verified' : 'Pending',
          ),
          DataGridCell<String>(
            columnName: 'lastLogin',
            value: user.attributes.createdAt,
          ),
          DataGridCell<String>(columnName: 'actions', value: user.id),
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
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: row.getCells()[0].value.isNotEmpty
                ? NetworkImage(row.getCells()[0].value)
                : null,
            backgroundColor: Colors.blue,
            child: row.getCells()[0].value.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(row.getCells()[1].value),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(row.getCells()[2].value),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(row.getCells()[3].value),
        ),
        Container(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: row.getCells()[4].value == 'Verified'
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              row.getCells()[4].value,
              style: TextStyle(
                color: row.getCells()[4].value == 'Verified'
                    ? Colors.green
                    : Colors.orange,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(row.getCells()[5].value),
        ),
        Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (row.getCells()[4].value == 'Pending')
                IconButton(
                  icon: const Icon(Icons.verified, color: Colors.green),
                  tooltip: 'Verify User',
                  onPressed: () => onVerify(row.getCells()[6].value),
                ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(row.getCells()[6].value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void updateDataSource(List<User> newUsers, {int? totalItems}) {
    users.clear();
    users.addAll(newUsers);
    if (totalItems != null) {
      this.totalItems = totalItems;
    }
    _buildDataRows();
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // This method is called when the user navigates to a different page
    // We'll handle this through the parent widget's getAllUser method
    return true;
  }
}

class UsersManagementPage extends StatefulWidget {
  UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  List<User> usersList = [];
  bool isLoading = true;
  int pendingUsers = 0;
  int verifiedUser = 0;
  int allUsers = 0;

  // Pagination variables
  int currentPage = 1;
  int totalPages = 1; // Start with 1 to avoid pageCount = 0 error
  int perPage = 10;
  int totalItems = 0;

  late UserDataSource _userDataSource;
  late DataPagerController _dataPagerController;
  late UniqueKey _pagerKey;
  late DataGridController _dataGridController;
  late UserDataPagerDelegate _dataPagerDelegate;

  Future<void> getAllUser({int? userId, int page = 1}) async {
    if (mounted) {
      setState(() {
        isLoading = true;
        currentPage = page;
      });
    }

    final result = await SimpleApiService.instance.makeRequest(
      method: ApiMethod.get,
      endpoint: "admin/users",
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
          });
        }
      },
      (data) {
        final paginationData = data['data'];
        if (mounted) {
          setState(() {
            usersList = List<User>.from(
              paginationData['data'].map((item) => User.fromJson(item)),
            );
            _userDataSource.updateDataSource(usersList, totalItems: totalItems);

            // Update pagination info
            totalItems = paginationData['meta']['total'] ?? 0;
            perPage = paginationData['meta']['per_page'] ?? 10;
            totalPages = totalItems > 0 ? (totalItems / perPage).ceil() : 1;
            // Ensure totalPages is never less than 1
            if (totalPages < 1) totalPages = 1;

            // Update the pager controller to highlight current page (0-based indexing)
            _dataPagerController.selectedPageIndex = currentPage - 1;

            // Force pager to rebuild with correct current page
            _pagerKey = UniqueKey();

            isLoading = false;
          });
        }
      },
    );
  }

  int CalculatePendingUser() {
    for (var user in usersList) {
      if (user.attributes.isVerified == false) pendingUsers++;
    }
    return pendingUsers;
  }

  int CalculateVerifiedUser() {
    for (var user in usersList) {
      if (user.attributes.isVerified == true) verifiedUser++;
    }
    return verifiedUser;
  }

  @override
  void initState() {
    super.initState();
    _dataPagerController = DataPagerController();
    _dataGridController = DataGridController();
    _pagerKey = UniqueKey();
    _dataPagerDelegate = UserDataPagerDelegate(
      _handlePageChange,
      _dataPagerController,
    );
    _userDataSource = UserDataSource(
      usersList,
      _verifyUser,
      _deleteUser,
      totalItems: totalItems,
    );
    getAllUser();
  }

  void _handlePageChange(int pageNumber) {
    // Force pager to rebuild when page changes
    if (mounted) {
      setState(() {
        _pagerKey = UniqueKey();
      });
    }
    getAllUser(page: pageNumber);
  }

  Future<void> _verifyUser(String userId) async {
    final result = await SimpleApiService.instance.makeRequest(
      method: ApiMethod.patch,
      endpoint: "admin/users/$userId/approve",
    );

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify user: $error')),
        );
      },
      (data) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User verified successfully')),
        );
        // Refresh the users list to show updated verification status
        getAllUser();
      },
    );
  }

  Future<void> _deleteUser(String userId) async {
    final result = await SimpleApiService.instance.makeRequest(
      method: ApiMethod.delete,
      endpoint: "admin/users/$userId",
    );

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete user: $error')),
        );
      },
      (data) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
        // Refresh the users list to show updated verification status
        getAllUser();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Users Management',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Total Users',
                  value: '${usersList.length}',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: StatCard(
                  title: 'Pending Approval',
                  value: '${CalculatePendingUser()}',
                  icon: Icons.pending,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: StatCard(
                  title: 'Verified User',
                  value: '${CalculateVerifiedUser()}',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Search and Filters
          Container(
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
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      DropdownMenuItem(value: 'user', child: Text('User')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'active', child: Text('Active')),
                      DropdownMenuItem(
                        value: 'blocked',
                        child: Text('Blocked'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Users Table
          SizedBox(
            height: 600, // تحديد ارتفاع ثابت للجدول
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
                  else if (usersList.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'No users found',
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
                          source: _userDataSource,
                          columns: [
                            GridColumn(
                              columnName: 'image',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Image'),
                              ),
                              width: 80,
                            ),
                            GridColumn(
                              columnName: 'name',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Name'),
                              ),
                            ),
                            GridColumn(
                              columnName: 'phone',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Phone'),
                              ),
                            ),
                            GridColumn(
                              columnName: 'role',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Role'),
                              ),
                            ),
                            GridColumn(
                              columnName: 'status',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Status'),
                              ),
                            ),
                            GridColumn(
                              columnName: 'lastLogin',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text('Last Login'),
                              ),
                            ),
                            GridColumn(
                              columnName: 'actions',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Actions'),
                              ),
                              width: 150,
                            ),
                          ],
                          columnWidthMode: ColumnWidthMode.fill,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          allowSorting: true,
                          allowMultiColumnSorting: false,
                          allowTriStateSorting: false,
                          controller: _dataGridController,
                        ),
                      ),
                    ),
                  if (!isLoading && usersList.isNotEmpty)
                    Column(
                      children: [
                        // Items count display
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Showing ${(currentPage - 1) * perPage + 1}-${(currentPage * perPage) > totalItems ? totalItems : currentPage * perPage} of $totalItems items',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SfDataPager(
                          key: _pagerKey,
                          controller: _dataPagerController,
                          pageCount: totalPages.toDouble(),
                          direction: Axis.horizontal,
                          delegate: _dataPagerDelegate,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
