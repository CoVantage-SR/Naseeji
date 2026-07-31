class RfqStats {
  final int newRequests;
  final int awaitingResponse;
  final int underNegotiation;
  final int approvedToday;

  const RfqStats({
    required this.newRequests,
    required this.awaitingResponse,
    required this.underNegotiation,
    required this.approvedToday,
  });
}



