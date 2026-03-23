import { UserActivity } from "../../../domain/user/userActivity.ts";
import type IUserRepository from "../../../application/ports/userRepository.ts";

export default class DeleteUserActivity{ 
    private repository: IUserRepository;
    private userID: number;
    private activityID: number;

    constructor(repository: IUserRepository, userID: number, activityID: number){
        this.repository = repository;
        this.userID = userID;
        this.activityID = activityID;
    }

    async execute(): Promise<void>{
        return await this.repository.deleteUserActivity(this.userID, this.activityID);
            
    }
}