import 'package:dashboard/core/sample_api/api_method.dart';
import 'package:dashboard/core/sample_api/api_service.dart';
import 'package:dashboard/models/user.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class UserDataSource extends DataGridSource {
  UserDataSource(
    this.users,
    this.onVerify,
    this.onDelete, {
    this.totalItems = 0,
    this.onPageChange,
  }) {
    _buildDataRows();
  }

  final List<User> users;
  int totalItems;
  final Function(String) onVerify;
  final Function(String) onDelete;
  final Function(int)? onPageChange;
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
    // Convert from 0-based index to 1-based page number
    final pageNumber = newPageIndex + 1;

    // Call the callback if provided
    if (onPageChange != null) {
      await onPageChange!(pageNumber);
    }

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
  int lastPage = 1;
  int perPage = 10;
  int totalItems = 0;
  bool isLoadingPage = false;

  late UserDataSource _userDataSource;

  Future<void> getAllUser({int page = 1, int perPage = 10}) async {
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
            isLoadingPage = false;
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
            currentPage = paginationData['meta']['current_page'] ?? 1;
            lastPage = totalItems > 0 ? (totalItems / perPage).ceil() : 1;
            // Ensure lastPage is never less than 1
            if (lastPage < 1) lastPage = 1;

            isLoading = false;
            isLoadingPage = false;
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
    _userDataSource = UserDataSource(
      usersList,
      _verifyUser,
      _deleteUser,
      totalItems: totalItems,
      onPageChange: _handlePageChange,
    );
    getAllUser();
  }

  Future<void> _handlePageChange(int pageNumber) async {
    await getAllUser(page: pageNumber, perPage: perPage);
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
        getAllUser(page: currentPage, perPage: perPage);
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
        getAllUser(page: currentPage, perPage: perPage);
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

          // Pagination Controls (Above Table)
          Visibility(
            visible: !isLoading && usersList.isNotEmpty,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
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
                        'Page $currentPage of $lastPage • Total: $totalItems users',
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
                                getAllUser(page: 1, perPage: value);
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
          ),

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
}
