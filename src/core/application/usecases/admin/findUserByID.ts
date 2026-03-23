import type IAdminRepository from "../../../application/ports/adminRepository.ts";
import { User } from "../../../domain/user/user.ts";

export default class FindUserByID{ 
    private repository: IAdminRepository;
    private userID: number;

    constructor(repository: IAdminRepository, userID: number){
        this.repository = repository;
        this.userID = userID;
    }

    async execute(): Promise<User | null>{
        return await this.repository.findUserByID(this.userID);
            
    }
}