class DummyGroupChatScreenData{
  String name = 'Work Group';
  String groupIcon = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_azxknR2LOno_BTqO4IAiq8gLGIqj2SY1xw&usqp=CAU';
  List participants = ['Rahul','Rupesh','Avi'];
  Map messages = {
    'mid1' : {
      'type' : 'text',
      'content' : 'Lorem ipsum dolor sit amet consectetur. Etiam eros sed pretium ridiculus egestas.',
      'timestamp' : '8:00 PM',
      'sender' : 'Rahul Sharma',
      'status' : 'sent',
    },
    'mid2' : {
      'type' : 'image',
      'content' : {
        'imageURL' : 'https://upload.wikimedia.org/wikipedia/commons/c/c8/Altja_j%C3%B5gi_Lahemaal.jpg',
        'caption' : 'Nature'
      },
      'timestamp' : '8:00 PM',
      'sender' : 'Shivam',
      'status' : 'sent'
    },
    'mid3' : {
      'type' : 'text',
      'content' : 'Lorem ipsum dolor sit amet consectetur. Etiam eros sed pretium ridiculus egestas.',
      'timestamp' : '8:00 PM',
      'sender' : 'Me',
      'status' : 'sent'
    },
    'mid4' : {
      'type' : 'text',
      'content' : 'Lorem ipsum dolor sit amet consectetur. Etiam eros sed pretium ridiculus egestas.',
      'timestamp' : '8:00 PM',
      'sender' : 'Rahul Sharma',
      'status' : 'sent'
    },
    'mid5' : {
      'type' : 'text',
      'content' : 'Lorem ipsum dolor sit amet consectetur. Etiam eros sed pretium ridiculus egestas.',
      'timestamp' : '8:00 PM',
      'sender' : 'Me',
      'status' : 'sent'
    },
  };
}