import type IAdminRepository from "../../repositories/adminRepository.ts";
import { User } from "../../../user/models/user.ts";

export default class FindUserByID{ 
    private repository: IAdminRepository;
    private userID: number;

    constructor(repository: IAdminRepository, userID: number){
        this.repository = repository;
        this.userID = userID;
    }

    async execute(): Promise<User | null>{
        // return await this.repository.findUserByID(this.userID);
        return null;
            
    }
}