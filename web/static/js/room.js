import UserInfo from './user_info';
import {
  setCurrentUser,
  openChat,
  receiveMessage,
  receiveHistoryMessages,
  receiveUserOnline,
  receiveUserOffline,
  receiveMultiUsersOnline,
  receiveAccessLog,
  receiveMultiAccessLogs,
} from './actions';

function room(socket, roomID, distinctID, store) {
  const messageEvent = 'new_message';
  const userLeft = 'user_left';
  const userJoin = 'user_join';
  const messages = 'messages';
  const userInfo = 'user_info';

  let channel = null;
  let onUserJoinedCallback = function func() { };

  function getHistory(userID) {
    if (typeof userID === 'undefined') {
      return channel.push(messages)
        .receive('ok', msgsResp => {
          store.dispatch(receiveHistoryMessages(msgsResp.messages));
        });
    }
    channel.push(messages, { uid: userID })
    .receive('ok', msgsResp => {
      store.dispatch(receiveHistoryMessages(msgsResp.messages));
    });
  }

  store.dispatch(setCurrentUser(distinctID));

  return {
    join() {
      if (!roomID) { return; }
      socket.connect();
      channel = socket.channel(`rooms:${roomID}`);

      channel.on(messageEvent, (msg) => {
        store.dispatch(receiveMessage(msg));
        store.dispatch(openChat(msg));
      });

      channel.on(userLeft, (user) => {
        store.dispatch(receiveUserOffline(user));
      });

      channel.on(userJoin, (user) => {
        store.dispatch(receiveUserOnline(user));
        getHistory(user.uid);
      });

      channel.on(userInfo, (resp) => {
        const accesslog = Object.assign({}, resp.info, { uid: resp.uid });
        store.dispatch(receiveAccessLog(accesslog));
      });

      channel.join()
        .receive('ok', () => {
          onUserJoinedCallback();
          channel.push(userInfo, UserInfo);
          const contactList = 'contact_list';
          channel.push(contactList)
            .receive('ok', listResp => {
              const users = listResp.users;
              if (users) {
                const newUsers = [];
                const newLogs = [];
                for (const key in users) {
                  if (users.hasOwnProperty(key)) {
                    const user = { uid: key };
                    newUsers.push(user);
                    const log = Object.assign({}, users[key], { uid: key });
                    newLogs.push(log);
                    getHistory(key);
                  }
                }
                store.dispatch(receiveMultiUsersOnline(newUsers));
                store.dispatch(receiveMultiAccessLogs(newLogs));
              }
            });
          // FIXME master need not do this
          channel.push(messages, { uid: distinctID })
            .receive('ok', msgsResp => {
              store.dispatch(receiveHistoryMessages(msgsResp.messages));
            });
        });
    },

    isSelf(uid) {
      return uid === distinctID;
    },

    send(text, toUser) {
      const message = { body: text, to_id: toUser };
      return channel.push(messageEvent, message);
    },

    onUserJoined(callback) {
      onUserJoinedCallback = callback;
    },
  };
}

export default room;
