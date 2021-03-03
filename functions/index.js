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
  const timeOfContact = data["timeOfContact"];

  const contactedUsersPromise = admin.firestore().collection("users").doc(userId).collection("ContactedUsers").get();

  contactedUsersPromise.then((contactedUsers) => {
    const contactedUsersFcmTokens = contactedUsers.docs.map((contactedUser) => contactedUser.id);
    const multicastMessage = {
      data: {message: "Someone who you came into contact with on" + timeOfContact + "has" + typeOfSickness},
      tokens: contactedUsersFcmTokens,
    };

    admin.messaging().sendMulticast(multicastMessage).then((response) => console.log("all good")).catch((error) => console.log(error));
  });
});
