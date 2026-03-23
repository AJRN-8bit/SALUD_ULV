import type IAdminRepository from "../../../application/ports/adminRepository.ts";
import { User } from "../../../domain/user/user.ts";

export default class GetAllUsers{ 
    private repository: IAdminRepository;

    constructor(repository: IAdminRepository){
        this.repository = repository;
    }

    async execute(): Promise<User[] | null>{
        return await this.repository.getAllUsers();
            
    }
}