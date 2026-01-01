class DashboardDataModel {
  final UsersData users;
  final ApartementsData apartements;
  final FinanceData finance;

  DashboardDataModel({
    required this.users,
    required this.apartements,
    required this.finance,
  });
  factory DashboardDataModel.fromJson(json) {
    return DashboardDataModel(
      users: UsersData.fromJson(json['data']['users']),
      apartements: ApartementsData.fromJson(json['data']['apartments']),
      finance: FinanceData.fromJson(json['data']['finance']),
    );
  }
}

class UsersData {
  final int total;
  final int pending;
  final int active;
  final int tanents;
  final int landlords;
  UsersData({
    required this.total,
    required this.pending,
    required this.active,
    required this.tanents,
    required this.landlords,
  });
  factory UsersData.fromJson(Map<String, dynamic> json) {
    return UsersData(
      total: json['total'],
      pending: json['pending'],
      active: json['active'],
      tanents: json['tanents'],
      landlords: json['landlords'],
    );
  }
}

class ApartementsData {
  final int total;
  final int rented;
  final int available;
  ApartementsData({
    required this.total,
    required this.rented,
    required this.available,
  });
  factory ApartementsData.fromJson(Map<String, dynamic> json) {
    return ApartementsData(
      total: json['total'],
      rented: json['rented'],
      available: json['available'],
    );
  }
}

class FinanceData {
  final double totalRevenue;

  FinanceData({required this.totalRevenue});
  factory FinanceData.fromJson(Map<String, dynamic> json) {
    return FinanceData(totalRevenue: json['total_revenue']);
  }
}
