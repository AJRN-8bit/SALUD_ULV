import type IAdminRepository from "../../repositories/adminRepository.ts";
import { User } from "../../../user/models/user.ts";

export default class FindUserByEmail{ 
    private repository: IAdminRepository;
    private userEmail: string;

    constructor(repository: IAdminRepository, userEmail: string){
        this.repository = repository;
        this.userEmail = userEmail;
    }

    async execute(): Promise<User | null>{
        // return await this.repository.findUserByEmail(this.userEmail);
        return null;
            
    }
}