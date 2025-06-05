String parseDeliveryOption(String deliveryOption) {
  if (deliveryOption == "default") {
    return "기본 배송";
  } else if (deliveryOption == "speed") {
    return "신속 배송";
  } else {
    return "안전 배송";
  }
}
