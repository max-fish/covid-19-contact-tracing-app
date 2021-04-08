/* eslint-disable max-len */
const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();


exports.notifyContactedUsers = functions.https.onCall((data, context) => {
  const userId = data["userId"];
  const typeOfSickness = data["sickness"];

  let statusMessage = "";

  if (typeOfSickness === "SickReason.SYMPTOMS") {
    statusMessage = "symptoms of COVID-19";
  } else {
    statusMessage = "has tested positive for COVID-19";
  }

  //uses firebase firestore library
  const contactedUsersPromise = admin.firestore().collection("users").doc(userId).collection("ContactedUsers").get();

  contactedUsersPromise.then((contactedUsers) => {
    contactedUsers.forEach((contactedUser) => {
      const timeOfContact = contactedUser.data().timeOfContact;

      const message = {
        notification: {
          //notificaiton contents
          title: "Contact Tracing Alert",
          body: "Someone who you came into contact with on " + timeOfContact + " has " + statusMessage,
        },
        data: {
          //contents that the app receives when notification is tapped
          title: "Contact Tracing Alert",
          body: "Someone who you came into contact with on " + timeOfContact + " has " + statusMessage,
          sickness: typeOfSickness,
          timeOfContact: timeOfContact,
          //allows the app to open upon tapping the notification
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        android: {
          priority: "high",
        },
        //which device to send it to
        token: contactedUser.id,
      };

      //send message to device
      //uses firebase messaging library
      admin.messaging().send(message).then((response) => console.log("all good")).catch((error) => console.log(error));
    });
  });
});

exports.removeOldContacts = () => {
  //uses firebase firestore library
  admin.firestore().collection('users').forEach(doc => {
    const contactedUsers = doc.collection("ContactedUsers").get();

    contactedUsers.forEach(contactedUser => {
      const timeOfContact = contactedUser["timeOfContact"];
      const currentDate = new Date();
      //if a contact is over 10 days old, remove the contact
      if(timeOfContact - currentDate.getDay() > 10){
        contactedUsers.delete(contactedUser);
      }
    });
  });
};
