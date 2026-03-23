import type IAdminRepository from "../../../application/ports/adminRepository.ts";
import { User } from "../../../domain/user/user.ts";

export default class FindUserByEmail{ 
    private repository: IAdminRepository;
    private userEmail: string;

    constructor(repository: IAdminRepository, userEmail: string){
        this.repository = repository;
        this.userEmail = userEmail;
    }

    async execute(): Promise<User | null>{
        return await this.repository.findUserByEmail(this.userEmail);
            
    }
}