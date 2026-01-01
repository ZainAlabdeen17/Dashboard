class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;
  final List<PaginationLink> links;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
    required this.links,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
      links: (json['links'] as List<dynamic>?)
          ?.map((link) => PaginationLink.fromJson(link))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'from': from,
      'to': to,
      'links': links.map((link) => link.toJson()).toList(),
    };
  }
}

class PaginationLink {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  PaginationLink({
    this.url,
    required this.label,
    this.page,
    required this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url'],
      label: json['label'] ?? '',
      page: json['page'],
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'page': page,
      'active': active,
    };
  }
}

class PaginationLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  PaginationLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory PaginationLinks.fromJson(Map<String, dynamic> json) {
    return PaginationLinks(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationLinks links;
  final PaginationMeta meta;
  final String message;
  final int status;

  PaginatedResponse({
    required this.data,
    required this.links,
    required this.meta,
    required this.message,
    required this.status,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => fromJson(item))
          .toList() ?? [],
      links: PaginationLinks.fromJson(json['links'] ?? {}),
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
      message: json['message'] ?? '',
      status: json['status'] ?? 200,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'links': links.toJson(),
      'meta': meta.toJson(),
      'message': message,
      'status': status,
    };
  }
}
