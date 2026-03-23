# Salud ULV API
This folder contains the API for the mobile application Salud ULV, for physical activity and anthropometric data registry.
This API is made in Typescript, so it highly recommended that the user or tester has typescript enabled in his environment and knows how to ruin it.

## Design
This API uses a basic implemetation of the hexagonal architecture, therefor it uses the domain, application and adapters layers.
The ***core*** folder represents the domain and application layers, and the ***features*** folder representes the adapters layer. 
Additionally, there is too a basic implementation of the SOLID principles, being the most prominent ones the Dependency invertion, Interface segregation and Sigle resposability. 


## Content
### Use cases
This is a multi-user API, therefor there is a User and Admin roles. Both roles have their own use cases. In the following subsection the use case of each role are listed.

#### User
1. Register by email.
2. Login.
3. Register personal info.
4. Get profile.
5. Register activity.
6. Register anthropometric data.
7. Get anthropometric data.
8. Get activities.
9. Delete an activity.

*Please note that the Register activity is still in working progress, so its possible that the activity won't register.*

#### Admin
1. Get all users profile
2. Get all users activities.
3. Get all users anthropometric data.
4. Get all groups.
5. Get all groups activities.
6. Get specific group activities.



### HTTP requests
This API makes requests and gets responses using the HTTP protocol. The previous use cases can be used with the following URL routes. Note that the routes are in the same order as the list of the use cases.

#### User
1. http://localhost:3000/api/v1/user/register
```json
{
  "userID": "112233",
  "email": "juan1@gmail.com",
  "password": "12345678A"
}
```

2. http://localhost:3000/api/v1/user/register/info
```json
{
  "userID": 112233,
  "name": "John",
  "firstName": "Price",
  "lastName": "Stone",
  "birthDate": "04-13-2004",
  "age": 32,
  "gender": "Male"
}
```

3. http://localhost:3000/api/v1/user/register/info
4. http://localhost:3000/api/v1/user/getProfile/112233
5. http://localhost:3000/api/v1/user/register/activity
```json
{
  "userID": 112233,
  "activityType": "Running",
  "distance": 2.4,
  "duration": "01:23:21",
  "caloriesBurned": 2243,
  "avgCadence": 23,
  "avgSpeed": 3.4,
  "maxSpeed": 5.6,
  "elevationGain": 26.3,
  "steps": 342
}
```

6. http://localhost:3000/api/v1/user/register/antrophometric
```json
{
  "userID": 112233,
  "height": 1.75,
  "weight": 67.9,
  "smm": 12.3,
  "fatMass": 43.2,
  "bodyFatPercentage": 12, 
  "bmi": 22.5,
  "whr": 21.3
}
```

7. http://localhost:3000/api/v1/user/anthData/112233
8. http://localhost:3000/api/v1/user/activities/112233
9. http://localhost:3000/api/v1/user/activities/112233/1

#### Admin
1. http://localhost:3000/api/v1/admin/allUsers
2. http://localhost:3000/api/v1/admin/allUsers/activities
3. http://localhost:3000/api/v1/admin/allUsers/anthData
4. http://localhost:3000/api/v1/admin/groups
5. http://localhost:3000/api/v1/admin/groups/activities
6. http://localhost:3000/api/v1/admin/groups/activities/1



### SQL Server database
This API uses a SQL Server database. In this folder there is a document called ***sqlCommands.sql*** that contains the commands to create a database with tables necessary for the functionality of this API. You can run that file in a SQL Server studio and you'll have a database ready to go.



## Run API
By the configurations of the content of the ***package.json*** file, the API should be up by running the following command.
```bash
npm run dev
```

Another to run the API is the need for an env file that has the following data.
```bash
USER= ''
PASSWORD= ''
SERVER='localhost'
DATABASE='SaludULVApp_DB_Test'

HOST='localhost'

PORT=3000
NODE_ENV=development
```
***Note: You need to fill the USER and PASSWORD fields with your SQL Server user and password.***