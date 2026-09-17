
// import type IGroupRepository from "../../repositories/groupRepository.ts";

// export default class RemoveUserFromGroup{
//     private repository: IGroupRepository;
//     private groupID: number;
//     private userID: number;

//     constructor(repository: IGroupRepository, groupID: number, userID: number){
//         this.repository = repository;
//         this.groupID = groupID;
//         this.userID = userID;
//     }

//     async execute(): Promise<void>{
//         // userExists = await this.repository.findUserByID();
//         // if(!userExists){ throw new Error('User not found'); }

//         // groupExists = await this.repository.findGroupByID();
//         // if(!groupExists){ throw new Error('Group not found'); }

//         await this.repository.removeUserFromGroup(this.groupID, this.userID);
//     }
// }