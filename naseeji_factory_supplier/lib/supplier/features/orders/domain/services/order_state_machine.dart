enum OrderStatus {
  rfqCreated,
  quotationSent,
  negotiation,
  finalAgreement,
  preparing,
  factoryReview,
  shipmentCreated,
  shipped,
  delivered,
  completed,
  paymentReleased,
  cancelled,
  expired,
  rejected,
  dispute,
}

class OrderStateMachine {
  static const Map<OrderStatus, Set<OrderStatus>> _allowedTransitions = {
    OrderStatus.rfqCreated: {OrderStatus.quotationSent, OrderStatus.rejected, OrderStatus.cancelled, OrderStatus.expired},
    OrderStatus.quotationSent: {OrderStatus.negotiation, OrderStatus.finalAgreement, OrderStatus.cancelled, OrderStatus.expired},
    OrderStatus.negotiation: {OrderStatus.finalAgreement, OrderStatus.cancelled, OrderStatus.dispute},
    OrderStatus.finalAgreement: {OrderStatus.preparing, OrderStatus.cancelled},
    OrderStatus.preparing: {OrderStatus.factoryReview, OrderStatus.dispute, OrderStatus.cancelled},
    OrderStatus.factoryReview: {OrderStatus.shipmentCreated, OrderStatus.preparing, OrderStatus.dispute, OrderStatus.cancelled},
    OrderStatus.shipmentCreated: {OrderStatus.shipped, OrderStatus.dispute, OrderStatus.cancelled},
    OrderStatus.shipped: {OrderStatus.delivered, OrderStatus.dispute},
    OrderStatus.delivered: {OrderStatus.completed, OrderStatus.dispute},
    OrderStatus.completed: {OrderStatus.paymentReleased},
    OrderStatus.paymentReleased: {},
    OrderStatus.cancelled: {},
    OrderStatus.expired: {},
    OrderStatus.rejected: {},
    OrderStatus.dispute: {OrderStatus.negotiation, OrderStatus.completed, OrderStatus.cancelled},
  };

  static bool isValidTransition(OrderStatus from, OrderStatus to) {
    return _allowedTransitions[from]?.contains(to) ?? false;
  }

  static void validateTransition(OrderStatus from, OrderStatus to) {
    if (!isValidTransition(from, to)) {
      throw Exception('Invalid order transition from $from to $to');
    }
  }
}



