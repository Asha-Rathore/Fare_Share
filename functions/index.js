const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firestore);
//db use for data get from firebase
var db = admin.firestore();

exports.notifyNewMessage = functions.firestore.document("/DailyRides/{dailyrideid}").onCreate(async (snapshot, context) => {
  if (snapshot.empty) {
    console.log("no device");
    return;
  }
  const message = snapshot.data();
  const querySnapshot = db.collection('Drivers').doc(message.driverid).collection('tokens').get();
  const token = (await querySnapshot).docs.map((snap) => snap.id);
  const payload = {
    notification: {
      title: "The Travel App",
      body: message.destination,
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
      priority: "high",
      sound: 'default',
    },
    data: {
      command: message.userid,
    },
  };
  return admin.messaging().sendToDevice(token, payload);
}
);

//InterCity Create
exports.IntercityRequest = functions.firestore.document("/InterCity/{interCityrideid}/InterCityDataUsers/{intercityuserid}").onCreate(async (snapshot, context) => {
  if (snapshot.empty) {
    console.log("no device");
    return;
  }
  const intercitydata = snapshot.data();
  console.log('iner city user data ---------------------------------');
  console.log(intercitydata.driverid);
 
  const newlyCreatedDocumentID = context.params.intercityuserid
  console.log(newlyCreatedDocumentID);
  console.log('iner city user data ---------------------------------');
  const querySnapshot = db.collection('Drivers').doc(intercitydata.driverid).collection('tokens').get();
  const token = (await querySnapshot).docs.map((snap) => snap.id);
  const payload = {
    notification: {
      title: "The Travel App",
      body: intercitydata.dropOffLoacation,
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
      priority: "high",
      sound: 'default',
    },
    data: {
      command1: intercitydata.email,
      icityid: newlyCreatedDocumentID,
    },
  };
  return admin.messaging().sendToDevice(token, payload);
}
);
//End interCity create doc

//Event Create
exports.EventRideRequest = functions.firestore.document("/Events/{eventRiderid}/EventsDataUsers/{eventRiderUserid}").onCreate(async (snapshot, context) => {
  if (snapshot.empty) {
    console.log("no device");
    return;
  }
  const eventRidedata = snapshot.data();
  console.log('Event city user data ---------------------------------');
  console.log(eventRidedata.driverid);
 
  const newlyCreatedDocumentID = context.params.eventRiderUserid
  console.log(newlyCreatedDocumentID);
  console.log('Event city user data ---------------------------------');
  const querySnapshot = db.collection('Drivers').doc(eventRidedata.driverid).collection('tokens').get();
  const token = (await querySnapshot).docs.map((snap) => snap.id);
  const payload = {
    notification: {
      title: "The Travel App",
      body: eventRidedata.dropOffLoacation,
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
      priority: "high",
      sound: 'default',
    },
    data: {
      commandevent: eventRidedata.email,
      eventid: newlyCreatedDocumentID,
    },
  };
  return admin.messaging().sendToDevice(token, payload);
}

);
//Event Cancel Request
exports.notifyCancelEventRide = functions.firestore.document("/Events/{eventRiderid}/EventsDataUsers/{eventRiderUserid}").onUpdate(async (change, context) => {
  const before = change.before.data()
  const after = change.after.data()
  // console.log(before.flag);
  if (before.flag === after.flag) {
    return null
  } else {
    const usedata = db.collection('UsersData').doc(before.email);
    const doc = await usedata.get();
    if (!doc.exists) {
      console.log('No such document!');
    } else {
      console.log('Document data:', doc.data());
      const token = doc.data()['UToken']
      const payload = {
        notification: {
          title: "The Travel App",
          body: "Your Request Canceled",
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
          priority: "high",
          sound: 'default',
        },
      };
      return admin.messaging().sendToDevice(token, payload);
    }
  }
});

//InterCity Cancel Request
exports.notifyCancelInterCity = functions.firestore.document("/InterCity/{interCityrideid}/InterCityDataUsers/{intercityuserid}").onUpdate(async (change, context) => {
  const before = change.before.data()
  const after = change.after.data()
  // console.log(before.flag);
  if (before.flag === after.flag) {
    return null
  } else {
    const usedata = db.collection('UsersData').doc(before.email);
    const doc = await usedata.get();
    if (!doc.exists) {
      console.log('No such document!');
    } else {
      console.log('Document data:', doc.data());
      const token = doc.data()['UToken']
      const payload = {
        notification: {
          title: "The Travel App",
          body: "Your Request Canceled",
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
          priority: "high",
          sound: 'default',
        },
      };
      return admin.messaging().sendToDevice(token, payload);
    }
  }
});

//daily ride cancel request
exports.notifyUpdatedoc = functions.firestore.document("/DailyRides/{dailyrideid}").onUpdate(async (change, context) => {
  const before = change.before.data()
  const after = change.after.data()
  if (before.flag === after.flag) {
    return null
  } else {
    const usedata = db.collection('UsersData').doc(before.userid);
    const doc = await usedata.get();
    if (!doc.exists) {
      console.log('No such document!');
    } else {
      console.log('Document data:', doc.data());
      const token = doc.data()['UToken']
      const payload = {
        notification: {
          title: "The Travel App",
          body: "Your Request Canceled",
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
          priority: "high",
          sound: 'default',
        },
      };
      return admin.messaging().sendToDevice(token, payload);
    }
  }
});



