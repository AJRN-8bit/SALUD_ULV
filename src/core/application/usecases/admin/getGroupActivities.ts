import type IAdminRepository from "../../repositories/adminRepository.ts";
import { type IGroupActivities } from "../../../domain/group/groupActivities.ts";

export default class GetGroupActivities{ 
    private repository: IAdminRepository;
    private groupID: number;

    constructor(repository: IAdminRepository, groupID: number){
        this.repository = repository;
        this.groupID = groupID;
    }

    async execute(): Promise<IGroupActivities[] | null>{
        return await this.repository.getGroupActivities(this.groupID);
            
    }
}