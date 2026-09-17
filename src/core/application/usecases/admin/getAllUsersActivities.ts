import type IAdminRepository from "../../repositories/adminRepository.ts";
import { type IUserActivity } from "../../../user/userActivity.ts";

export default class GetAllUsersActivities{ 
    private repository: IAdminRepository;

    constructor(repository: IAdminRepository){
        this.repository = repository;
    }

    async execute(): Promise<IUserActivity[] | null>{
        return await this.repository.getAllUsersActivities();
            
    }
}