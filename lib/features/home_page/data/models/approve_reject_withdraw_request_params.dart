class ApproveRejectWithdrawRequestParams {
  String? requestId;
  String? status;
  String? remarks;

  ApproveRejectWithdrawRequestParams(this.requestId, this.status, this.remarks);

  Map<String, dynamic> toJson() => {
    if (status != null) "status": status,
    if (remarks != null) "remarks": remarks,
  };

}
