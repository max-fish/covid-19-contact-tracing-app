enum SickReason{
  SYMPTOMS,
  POSITIVE_TEST
}

SickReason getReasonFromString(String stringedReason) {
  for (SickReason reason in SickReason.values) {
    if(reason.toString() == stringedReason) {
      return reason;
    }
  }
  return null;
}