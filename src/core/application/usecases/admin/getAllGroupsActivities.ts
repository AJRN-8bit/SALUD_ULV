import type IAdminRepository from "../../repositories/adminRepository.ts";
import { type IGroupActivities } from "../../../domain/group/groupActivities.ts";

export default class GetAllGroupsActivities{ 
    private repository: IAdminRepository;

    constructor(repository: IAdminRepository){
        this.repository = repository;
    }

    async execute(): Promise<IGroupActivities[] | null>{
        return await this.repository.getAllGroupsActivities();
            
    }
}