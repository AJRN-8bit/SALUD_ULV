import { UserActivity } from "../../../domain/user/userActivity.ts";
import type IUserRepository from "../../../application/ports/userRepository.ts";

export default class GetUserActivities{ 
    private repository: IUserRepository;
    private userID: number;

    constructor(repository: IUserRepository, userID: number){
        this.repository = repository;
        this.userID = userID;
    }

    async execute(): Promise<UserActivity[] | null>{
        return await this.repository.getAllUserActivities(this.userID);
            
    }
}