typedef UserRecord = ({String name, int age});

// Get pieces of the record
int getUserAge(UserRecord user) => user.age;
String getUserName(UserRecord user) => user.name;
