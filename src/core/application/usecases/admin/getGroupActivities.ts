import type IAdminRepository from "../../../application/ports/adminRepository.ts";
import { GroupActivities } from "../../../domain/group/groupActivities.ts";

export default class GetGroupActivities{ 
    private repository: IAdminRepository;
    private groupID: number;

    constructor(repository: IAdminRepository, groupID: number){
        this.repository = repository;
        this.groupID = groupID;
    }

    async execute(): Promise<GroupActivities[] | null>{
        return await this.repository.getGroupActivities(this.groupID);
            
    }
}