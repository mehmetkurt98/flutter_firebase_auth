const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendDailyNotification = functions.pubsub
  .schedule("*/2 * * * *")
  .timeZone("Europe/Istanbul")
  .onRun((context) => {


    const payload = {
      notification: {
        title: "Günün Yemek Menüsü",
        body: "Tıklayarak günün yemek menüsünü görebilirsiniz.",
      },

    };

    admin
      .firestore()
      .collection("users")
      .get()
      .then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
          const user = doc.data();
          admin.messaging().sendToDevice(user.token, payload);
        });
        return null;
      })
      .catch((error) => {
        console.error("Error sending daily notification:", error);
      });

    return null;
  });
