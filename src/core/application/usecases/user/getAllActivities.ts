// import { type IUserActivity } from "../../../domain/user/userActivity.ts";
// import type IUserRepository from "../../ports/primary";
// import type IUserRepository from "../../ports/secondary";

// export default class GetAllUserActivities{ 
//     private repository: IUserRepository;
//     private userID: number;

//     constructor(repository: IUserRepository, userID: number){
//         this.repository = repository;
//         this.userID = userID;
//     }

//     async execute(): Promise<IUserActivity[] | null>{
//         const foundUser = await this.repository.findUserByID(this.userID);
//         if(!foundUser){ throw new Error('User not found'); }
        
//         return await this.repository.getUserActivities(this.userID);
        
//     }
// }