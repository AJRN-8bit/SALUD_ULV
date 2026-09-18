// // import type { IGroup } from "../../../models/groups.ts";
// import { Group, type IGroup } from "../../../models/groups.ts";
// import type { IGroupRepo } from "../../repositories/repos/groups_repo.ts";
// import type { IGetGroupWithMembersUseCase } from "../../repositories/use-cases/group_usecases.ts";


// export class GetGroupWithMembersUseCase implements IGetGroupWithMembersUseCase {
//     private repository: IGroupRepo;

//     constructor(repository: IGroupRepo){
//         this.repository = repository;
//     }


//     async execute(groupID: number): Promise<IGroup | null> {
//         const groupExists = await this.repository.groupExists(groupID);
//         if(!groupExists) throw new Error('Group doesnt exists');

//         const groupInfo = await this.repository.getGroupInfo(groupID);
//         if(groupInfo == null) throw new Error('Could not get group info');

//         var groupMembers = await this.repository.getGroupMembers(groupID);
//         if(groupMembers == null) groupMembers = [];

//         // console.log(groupInfo.name!);
//         // console.log(groupInfo.description!);
//         // console.log(groupInfo.building!);

//         const group = new Group(
//             groupInfo.name!,
//             groupInfo.description!,
//             groupInfo.building!,
//             groupMembers,
//             groupInfo.groupID!,
//         );

//         return group;
//     }
// }