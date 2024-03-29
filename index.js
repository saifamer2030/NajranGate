'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendAlarmNotification = functions.database.ref('/Alarm/{recieverUid}/{pushid}')
    .onWrite(async (change, context) => {
        
    //   const sendUid = context.params.senderUid;
      const recUid = context.params.recieverUid;
      const pushId = context.params.pushid;

      // If un-follow we exit the function.
      if (!change.after.val()) {
        return console.log('PushId ', pushId , ' recieve : ' ,recUid);
      }
      console.log('PushId:', pushId);
      console.log('reciever UID:', recUid);

          const userName = admin.database().ref(`/userdata/${recUid}/cName`).once('value');
          const msge = admin.database().ref(`/Alarm/${recUid}/${pushId}/cType`).once('value');
          const wid = admin.database().ref(`/Alarm/${recUid}/${pushId}/wid`).once('value');

          // Get the follower profile.
        //   const getFollowerProfilePromise = admin.database()
        //   ref(`/Alarm/{recieverUid}/{pushid}/cType`).once('value');

        // const getFollowerProfilePromise = admin.database()
        // .ref(`/Alarm/${recUid}/${pushId}/cType`).once('value');
    
        const results = await Promise.all([ msge ,userName,wid ]);
          const msg = results[0];
          const sen = results[1];
          const Cid = results[2];

          const payload = {
            notification:{
                // title : `رسالة جديدة من ${sen.val()}`,
                title : `بوابة نجران - لديك اشعار جديد`,
                body : `لديك ${msg.val()} جديد  `,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                id:`${Cid.val()}`,
                badge: '1',
                sound: 'default'

            },

        };
    
        return admin.database().ref(`/Fcm-Token/${recUid}`).once('value').then(allToken => {
            if(allToken.val()){

                console.log('inside', allToken.val().Token);

               // const token = Object.keys(allToken.val());

                var str =  allToken.val().Token;
                console.log('token available str ',str);
                return admin.messaging().sendToDevice(str,payload);
            }else{
                console.log('No token available');
            }
        });
      


      
    });