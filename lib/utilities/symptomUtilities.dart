//types of symptoms
enum Symptom { HIGH_TEMP, COUGH, CHANGE_SMELL_TASTE }

// helper class
class SymptomUtilities {
  //gets a description based on the symptom
  static String getDescription(Symptom symptom) {
    switch (symptom) {
      case Symptom.HIGH_TEMP:
        return 'A high temperature (fever)';
      case Symptom.COUGH:
        return 'A new continuous cough';
      case Symptom.CHANGE_SMELL_TASTE:
        return 'A change to your sense of smell or taste';
      default:
        return '';
    }
  }
}
