import type IAdminRepository from "../../../application/ports/adminRepository.ts";
import { Group } from "../../../domain/group/group.ts";

export default class GetAllGroups{ 
    private repository: IAdminRepository;

    constructor(repository: IAdminRepository){
        this.repository = repository;
    }

    async execute(): Promise<Group[] | null>{
        return await this.repository.getAllGroups();
            
    }
}