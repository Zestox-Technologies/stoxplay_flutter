class QueryParams {
  int? page;
  int? limit;

  QueryParams(this.limit, this.page) {
    page = 1;
    limit = 10;
  }

  Map<String, dynamic> toMap() => {"page": page, "limit": limit};
}
