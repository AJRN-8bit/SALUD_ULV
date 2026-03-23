import type IAdminRepository from "../../../application/ports/adminRepository.ts";
import { UserAnthropometric } from "../../../domain/user/userAntroph.ts";

export default class GetAllUsersAnthropometricData{ 
    private repository: IAdminRepository;

    constructor(repository: IAdminRepository){
        this.repository = repository;
    }

    async execute(): Promise<UserAnthropometric[] | null>{
        return await this.repository.getAllUsersAnthropometricData();
            
    }
}