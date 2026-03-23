import type {Express, Request, Response} from "express";
import SQLRepository from "../../../repositories/mssql/user_sqlRepository.ts";
import {RegisterUser, RegisterUserInfo, UserLogin} from "../../../../core/services/auth/userAuth.ts";
import {GetUserProfile, RegisterUserActivity, 
    RegisterUserAnthropometricData, GetAllUserAntrophometricData, 
    GetAllUserActivities, DeleteUserActivity} from "../../../../core/application/usecases/user/index.ts";


const repository = new SQLRepository();

const apiVersion = '/api/v1/user';

export default function userRoutes(app: Express){

//--------------------------------------------------------------------------------------------------------------------------
    app.post(`${apiVersion}/register`, async (req: Request, res: Response) => {
        try {
            const userID = Number(req.body.userID);
            const {email, password} = req.body;

            const registerUser: RegisterUser = new RegisterUser(repository, {userID, email, password});
            const newUser = await registerUser.execute();
            
            res.status(201).json({content: newUser, message: 'User registered succesfully'});

        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while registering user', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.post(`${apiVersion}/login`, async (req: Request, res: Response) => {
        try {
            const {email, password} = req.body;

            const userLogin: UserLogin = new UserLogin(repository, {email, password});
            await userLogin.execute();

            res.status(200).json({message: 'User logged in succesfully'});
            
        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while logging in user', error: error});
        }
    });



//--------------------------------------------------------------------------------------------------------------------------
    app.post(`${apiVersion}/register/info`, async (req: Request, res: Response) => {
        try {
            const {userID, name, firstName, lastName, birthDate, age, gender} = req.body;

            const registerUserInfo: RegisterUserInfo = new RegisterUserInfo(repository, {
                userID, name, firstName, lastName, birthDate, age, gender
            });
            const nweUserInfo = await registerUserInfo.execute();
            
            res.status(201).json({content: nweUserInfo, message: 'User info registered succesfully'});

        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while registering user info', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.get(`${apiVersion}/getProfile/:userID`, async (req: Request, res: Response) => {
        try {
            const userID = Number(req.params.userID);

            const getUserProfile: GetUserProfile = new GetUserProfile(repository, userID);
            const userProfile = await getUserProfile.execute();
            // console.log(userProfile);
            res.status(200).json({user: userProfile});
            
        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while getting user profile', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.post(`${apiVersion}/register/antrophometric`, async (req: Request, res: Response) => {
        try {
            const {userID, height, weight, smm, fatMass, bodyFatPercentage, bmi, whr} = req.body;

            const registerUserAntrophometricData = new RegisterUserAnthropometricData(repository, {
                userID, height, weight, smm, fatMass, bodyFatPercentage, bmi, whr
            });
            const newAntrophData = await registerUserAntrophometricData.execute();
            
            res.status(201).json({content: newAntrophData, message: 'User antrophometric data registered succesfully'});
            
        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while registering data', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.get(`${apiVersion}/anthData/:userID`, async (req: Request, res: Response) => {
        try {
            const userID = Number(req.params.userID);

            const getAllUserAntrophometricData: GetAllUserAntrophometricData = new GetAllUserAntrophometricData(repository, userID);
            const userAnthData = await getAllUserAntrophometricData.execute();

            res.status(200).json({activities: userAnthData});

        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while getting user activities', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.post(`${apiVersion}/register/activity`, async (req: Request, res: Response) => {
        try {
            const {userID, activityType, distance, duration, caloriesBurned, avgCadence, avgSpeed, maxSpeed, elevationGain, steps} = req.body;

            const registerUserActivity: RegisterUserActivity = new RegisterUserActivity(repository,{
                userID, activityType, distance, duration, caloriesBurned, avgCadence, avgSpeed, maxSpeed, elevationGain, steps
            });

            const newActivity = await registerUserActivity.execute();

            res.status(201).json({activity: newActivity});

        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while registering user activity', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.get(`${apiVersion}/activities/:userID/`, async (req: Request, res: Response) => {
        try {
            const userID = Number(req.params.userID);

            const getAllUserActivities: GetAllUserActivities = new GetAllUserActivities(repository, userID);
            const userActivities = await getAllUserActivities.execute();

            res.status(200).json({activities: userActivities});

        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while getting user activities', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.delete(`${apiVersion}/activities/:userID/:activityID`, async (req: Request, res: Response) => {
        try {
            const userID = Number(req.params.userID);
            const activityID = Number(req.params.activityID);

            const deleteUserActivity: DeleteUserActivity = new DeleteUserActivity(repository, userID, activityID);
            await deleteUserActivity.execute();

            res.status(200).json({message: "Activity deleted successfully"});

        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while deleting user activity', error: error});
        }
    });
}
