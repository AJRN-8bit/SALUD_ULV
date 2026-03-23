import { User } from "../../../domain/user/user.ts";
import type IUserRepository from "../../../application/ports/userRepository.ts";

export default class GetUserProfile{ 
    private repository: IUserRepository;
    private userID: number;

    constructor(repository: IUserRepository, userID: number){
        this.repository = repository;
        this.userID = userID;
    }

    async execute(): Promise<User | null>{
        return await this.repository.getUserProfile(this.userID);
            
    }
}