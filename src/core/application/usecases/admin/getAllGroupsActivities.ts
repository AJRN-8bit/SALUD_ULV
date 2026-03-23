import type IAdminRepository from "../../../application/ports/adminRepository.ts";
import { GroupActivities } from "../../../domain/group/groupActivities.ts";

export default class GetAllGroupsActivities{ 
    private repository: IAdminRepository;

    constructor(repository: IAdminRepository){
        this.repository = repository;
    }

    async execute(): Promise<GroupActivities[] | null>{
        return await this.repository.getAllGroupsActivities();
            
    }
}