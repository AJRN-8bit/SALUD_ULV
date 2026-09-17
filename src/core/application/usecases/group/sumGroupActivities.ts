// import type { IGroupActivities } from "../../../domain/group/groupActivities.ts";
// import type IGroupRepository from "../../repositories/groupRepository.ts";

// export default class sumAllActivitiesByGroup{
//     private repository: IGroupRepository;
//     private groupID: number;

//     constructor(repository: IGroupRepository, groupID: number){
//         this.repository = repository;
//         this.groupID = groupID;
//     }

//     async execute(): Promise<IGroupActivities[] | null>{
//         return await this.repository.sumGroupActivities(this.groupID);
//     }
// }