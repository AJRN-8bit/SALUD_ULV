import type IAdminRepository from "../../../application/ports/adminRepository.ts";
import { UserActivity } from "../../../domain/user/userActivity.ts";

export default class GetAllUsersActivities{ 
    private repository: IAdminRepository;

    constructor(repository: IAdminRepository){
        this.repository = repository;
    }

    async execute(): Promise<UserActivity[] | null>{
        return await this.repository.getAllUsersActivities();
            
    }
}