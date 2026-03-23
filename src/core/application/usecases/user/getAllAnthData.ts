import { UserAnthropometric } from "../../../domain/user/userAntroph.ts";
import type IUserRepository from "../../../application/ports/userRepository.ts";

export default class GetUserAntrophometricData{ 
    private repository: IUserRepository;
    private userID: number;

    constructor(repository: IUserRepository, userID: number){
        this.repository = repository;
        this.userID = userID;
    }

    async execute(): Promise<UserAnthropometric[] | null>{
        return await this.repository.getAllUserAntrophometricData(this.userID);
            
    }
}