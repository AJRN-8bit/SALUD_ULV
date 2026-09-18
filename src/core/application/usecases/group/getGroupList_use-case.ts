// import type { IGroup } from "../../../models/groups.ts";
// import type { IGroupRepo } from "../../repositories/repos/groups_repo.ts";
// import type { IGetGroupsList } from "../../repositories/use-cases/group_usecases.ts";


// export class GetGroupsListUseCase implements IGetGroupsList {
//     private repository: IGroupRepo;

//     constructor(repository: IGroupRepo){
//         this.repository = repository
//     }

//     async execute(typeID: number): Promise<IGroup[] | null> {

//         const groups = await this.repository.getGroupsList(typeID);
//         if(groups == null) return null;

//         return groups;
//     }
// }