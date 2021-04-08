//possible sickness statuses
enum SickReason{
  SYMPTOMS,
  POSITIVE_TEST,
  NOT_SICK
}

//get sickness status from a string
SickReason getReasonFromString(String stringedReason) {
  for (SickReason reason in SickReason.values) {
    if(reason.toString() == stringedReason) {
      return reason;
    }
  }
  return null;
}