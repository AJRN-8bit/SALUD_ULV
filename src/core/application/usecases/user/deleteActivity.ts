// import { UserActivity } from "../../../user/userActivity.ts";
// import type IUserRepository from "../../repositories/userRepository.ts";

// export default class DeleteUserActivity{ 
//     private repository: IUserRepository;
//     private userID: number;
//     private activityID: number;

//     constructor(repository: IUserRepository, userID: number, activityID: number){
//         this.repository = repository;
//         this.userID = userID;
//         this.activityID = activityID;
//     }

//     async execute(): Promise<void>{
//         const foundUser = await this.repository.findUserByID(this.userID);
//         if(!foundUser){ throw new Error('User not found'); }

//         const foundActivity = await this.repository.findUserActivityByID(this.userID, this.activityID);
//         if(!foundActivity){ throw new Error('Activity not found'); }

//         await this.repository.deleteUserActivity(this.userID, this.activityID);
//     }
// }