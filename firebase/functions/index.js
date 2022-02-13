// 'use strict';

// The Cloud Functions for Firebase SDK
const functions = require("firebase-functions");

// The Firebase Admin SDK
const admin = require("firebase-admin");
admin.initializeApp();

/**
 * Truncate message text body
 * @param {string} text to truncate
 * @return {string} truncated string if too long, original if not
 */
function truncateText(text) {
  if (text.length > 100) {
    return (text.substring(0, 96) + "...");
  }
  return (text);
}

exports.notify = functions.database
  .ref("/threads/{threadUid}/messages/{messageUid}").onWrite(
    async (change, context) => {
      const threadUid = context.params.threadUid;
      const messageUid = context.params.messageUid;
      const snapshot = change.after;
      const author = snapshot.child("authorName").val();
      const text = truncateText(snapshot.child("text").val());

      functions.logger.log("Trigger for thread ",
        threadUid, " message ", messageUid);

      const payload = {
        notification: {
          title: author,
          body: text,
        },
      };

      // Send notification payload
      const response = await admin.messaging()
        .sendToTopic(threadUid, payload);
      const error = response.error;
      if (error) {
        functions.logger
          .error("Failure to send notification to general, error: ",
            error);
      }
    });

exports.newUser = functions.firestore.document('users/{userUid}').onCreate((snapshot, context) => {
  // Add welcome threads to new user's thread subscriptions
  const newSubscriptions = ["welcomeThread1", "welcomeThread2"];
  functions.logger.log("Adding welcome package to user ", context.params.userUid);

  return snapshot.ref.set({"subscribedThreads": newSubscriptions}, {merge: true});
});

// https://firebase.google.com/docs/functions/write-firebase-functions
