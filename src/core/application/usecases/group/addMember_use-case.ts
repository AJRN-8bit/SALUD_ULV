import type { IAuthRepo } from "../../repositories/repos/auth_repo.ts";
import type { IGroupRepo } from "../../repositories/repos/groups_repo.ts";
import type { IAddMemberUseCase } from "../../repositories/use-cases/group_usecases.ts";


export default class AddMemberUserCase implements IAddMemberUseCase{
    private repository: IGroupRepo;

    constructor(repository: IGroupRepo){
        this.repository = repository
    }

    async execute(groupID: number, userUUID: string): Promise<void> {
        const groupExists = await this.repository.groupExists(groupID);
        if(!groupExists) throw new Error("Group dosent exist")

        const userExists = await this.repository.userExists(userUUID);
        if(!userExists) throw new Error("User dosent exsits");

        console.log("adding memeber to group");
        await this.repository.addMember(groupID, userUUID);
        console.log("member added to a group");
        return;
    }
}