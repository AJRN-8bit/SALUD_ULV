// import type { IUserActivity } from "../../../domain/user/userActivity.ts";
// import type IUserRepository from "../../../application/ports/userRepository.ts";

// export default class RegisterUserActivity{ 
//     private repository: IUserRepository;
//     private userActivity: IUserActivity;

//     constructor(repository: IUserRepository, userActivity: IUserActivity){
//         this.repository = repository;
//         this.userActivity = userActivity;
//     }

//     async execute(): Promise<void>{
//         const userExists = await this.repository.findUserByID(this.userActivity.userID);
//         if(!userExists){throw new Error('User not found');}

//         await this.repository.registerUserActivity(this.userActivity);
//     }
// }