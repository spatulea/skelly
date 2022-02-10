// 'use strict';

// The Cloud Functions for Firebase SDK to create Cloud Functions
// and set up triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Realtime Database.
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
      const author = snapshot.child("author").val();
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
        .sendToTopic("general", payload);
      const error = response.error;
      if (error) {
        functions.logger
          .error("Failure to send notification to general, error: ",
            error);
      }
    });

// https://firebase.google.com/docs/functions/write-firebase-functions
