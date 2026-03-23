import type {Express, Request, Response} from "express";
import SQLRepository from "../../../repositories/mssql/admin_sqlRepository.ts";
import {    
    GetAllUsers,
    FindUserByEmail,
    FindUserByID,
    GetAllUsersActivities,
    GetAllUsersAnthropometricData,
    GetAllGroups,
    GetAllGroupsActivities,
    GetGroupActivities } from "../../../../core/application/usecases/admin/index.ts";
import { group } from "node:console";


const repository = new SQLRepository();

const apiVersion = '/api/v1/admin';

export default function adminRoutes(app: Express){  //     FindUserByEmail, FindUserByID missing

//--------------------------------------------------------------------------------------------------------------------------
    app.get(`${apiVersion}/allUsers`, async (req: Request, res: Response) => {
        try {

            const getAllUsers: GetAllUsers = new GetAllUsers(repository);
            const users = await getAllUsers.execute();
            
            res.status(200).json({data: users});
            
        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while registering user', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.get(`${apiVersion}/allUsers/activities`, async (req: Request, res: Response) => {
        try {

            const getAllUsersActivities: GetAllUsersActivities = new GetAllUsersActivities(repository);
            const usersActivities = await getAllUsersActivities.execute();
            
            res.status(200).json({data: usersActivities});
            
        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while registering user', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.get(`${apiVersion}/allUsers/anthData`, async (req: Request, res: Response) => {
        try {

            const getAllUsersAnthropometricData: GetAllUsersAnthropometricData = new GetAllUsersAnthropometricData(repository);
            const usersAnthropometricData = await getAllUsersAnthropometricData.execute();
            
            res.status(200).json({data: usersAnthropometricData});
            
        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while registering user', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.get(`${apiVersion}/groups`, async (req: Request, res: Response) => {
        try {

            const getAllGroups: GetAllGroups = new GetAllGroups(repository);
            const groups = await getAllGroups.execute();
            
            res.status(200).json({data: groups});
            
        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while registering user', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.get(`${apiVersion}/groups/activities`, async (req: Request, res: Response) => {
        try {

            const getAllGroupsActivities: GetAllGroupsActivities = new GetAllGroupsActivities(repository);
            const groupsActivities = await getAllGroupsActivities.execute();
            
            res.status(200).json({data: groupsActivities});
            
        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while registering user', error: error});
        }
    });


//--------------------------------------------------------------------------------------------------------------------------
    app.get(`${apiVersion}/groups/activities/:groupID`, async (req: Request, res: Response) => {
        try {
            const groupID = Number(req.params.groupID);
        
            const getGroupActivities: GetGroupActivities = new GetGroupActivities(repository, groupID);
            const groupActivities = await getGroupActivities.execute();
            
            res.status(200).json({data: groupActivities});
            
        } catch (error) {
            console.log(error);
            res.status(500).json({message: 'Error while registering user', error: error});
        }
    });
    

}