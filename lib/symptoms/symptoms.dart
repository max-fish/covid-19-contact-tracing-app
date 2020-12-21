enum Symptom { HIGH_TEMP, COUGH, CHANGE_SMELL_TASTE }

class SymptomUtilities {
  static String getDescription(Symptom symptom) {
    switch (symptom) {
      case Symptom.HIGH_TEMP:
        return "A high temperature (fever)";
      case Symptom.COUGH:
        return "A new continuous cough";
      case Symptom.CHANGE_SMELL_TASTE:
        return "A change to your sense of smell or taste";
      default:
        return "";
    }
  }
}
