'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendChatNotification = functions.database.ref('/Chats/{senderUid}/{recieverUid}/{pushid}')
    .onWrite(async (change, context) => {
        
      const sendUid = context.params.senderUid;
      const recUid = context.params.recieverUid;
      const pushId = context.params.pushid;

      // If un-follow we exit the function.
      if (!change.after.val()) {
        return console.log('User ', sendUid , '- recieve : ' ,recUid);
      }
      console.log('sender UID:', sendUid);
      console.log('reciever UID:', recUid);

          const userName = admin.database().ref(`/coiffuredata/${sendUid}/cName`).once('value');

          // Get the follower profile.
          const getFollowerProfilePromise = admin.database()
          .ref(`/Chats/${sendUid}/${recUid}/${pushId}/message`).once('value');
    
          const results = await Promise.all([ getFollowerProfilePromise ,userName ]);
          const msg = results[0];
          const sen = results[1];

          const payload = {
            notification:{
                title : `رسالة جديدة من ${sen.val()}`,
                body : `${msg.val()}`,
                badge : '1',
                icon: 'https://firebasestorage.googleapis.com/v0/b/beautyflutter-156c2.appspot.com/o/logo%2Flogo2020_small.png?alt=media&token=571dcb3b-8474-45f6-84d6-a5d5a73aef8d',
                sound : 'default'
            }
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

    //booking notification
// exports.sendBookingNotification = functions.database.ref('/coiffure_booking/{catid}/{date_str}/{userId}')
//     .onWrite(async (change, context) => {


//       //const providerUid = context.params.provuid;
//       const userUid = context.params.userId;
//       const booking_date = context.params.date_str;
//       const coifId = context.params.catid;

//       console.log('userUid: ', userUid, '- cof : ', coifId , '- booking_date : ', booking_date);

//       const userName = admin.database().ref(`/coiffuredata/${userUid}/cName`).once('value');


//           // Get the follower profile.
//           const getFollowerProfilePromise = admin.database()
//           .ref(`/coiffuredata/${coifId}/cName`).once('value');
    
//           // The array containing all the user's tokens.
//           let tokens;
    
//           const results = await Promise.all([ getFollowerProfilePromise ,userName ]);
//           const follower = results[0];
//           const prov2 = results[1];

//       console.log('user : ', prov2.val());


//       // Notification details.
//       const payload = {
//         notification: {
//           title: `${follower.val()} لديك حجز جديد `,
//           body: `${prov2.val()} , قام بحجز خدمة لديك ${booking_date}.`,
//           badge : '1',
//           sound : 'default' ,
//         }
//       };

//       return admin.database().ref(`/Fcm-Token/${coifId}`).once('value').then(allToken => {
//         if(allToken.val()){

//             console.log('Token', allToken.val().Token);
//            // const token = Object.keys(allToken.val());

//             var str =  allToken.val().Token;
//             console.log('token available str $str ${str} ',str);
//             return admin.messaging().sendToDevice(str,payload);
//         }else{
//             console.log('No token available');
//         }
//     });


//     });
