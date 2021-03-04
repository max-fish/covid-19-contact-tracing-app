/* eslint-disable max-len */
const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.notifyContactedUsers = functions.https.onCall((data, context) => {
  const userId = data["userId"];
  const typeOfSickness = data["sickness"];

  let statusMessage = "";

  if (typeOfSickness === "SickReason.SYMPTOMS") {
    statusMessage = "symptoms of COVID-19";
  } else {
    statusMessage = "has tested positive for COVID-19";
  }

  const contactedUsersPromise = admin.firestore().collection("users").doc(userId).collection("ContactedUsers").get();

  contactedUsersPromise.then((contactedUsers) => {
    contactedUsers.forEach((contactedUser) => {
      const message = {
        notification: {
          title: "Contact Tracing Alert",
          body: "Someone who you came into contact with on " + contactedUser.data().timeOfContact + " has " + statusMessage,
        },
        data: {
          title: "Contact Tracing Alert",
          body: "Someone who you came into contact with on " + contactedUser.data().timeOfContact + " has " + statusMessage,
          sickness: typeOfSickness,
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        android: {
          priority: "high",
        },
        token: contactedUser.id,
      };

      admin.messaging().send(message).then((response) => console.log("all good")).catch((error) => console.log(error));
    });
  });
});
