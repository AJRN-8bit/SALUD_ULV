import { UserActivity } from "../../../domain/user/userActivity.ts";
import type { IUserActivityRegistry } from "../../../domain/user/userActivity.ts";
import type IUserRepository from "../../../application/ports/userRepository.ts";

export default class RegisterUserActivity{ 
    private repository: IUserRepository;
    private userActivity: IUserActivityRegistry;

    constructor(repository: IUserRepository, userActivity: IUserActivityRegistry){
        this.repository = repository;
        this.userActivity = userActivity;
    }

    async execute(): Promise<void>{
        return await this.repository.registerUserActivity(this.userActivity);
            
    }
}