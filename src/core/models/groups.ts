import type { IUser } from "./user.ts";

export interface IGroup {
    readonly groupID?: number | undefined;
    readonly name?: string;
    readonly description?: string;
    // readonly building?: string | undefined;
    readonly members?: IUser[] | undefined;
}

export class Group implements IGroup {
    readonly groupID?: number | undefined;
    readonly name?: string;
    readonly description?: string;
    // readonly building?: string;
    readonly members?: IUser[];

    constructor(
        name: string,
        description: string,
        // building: string,
        members: IUser[] = [],
        groupID?: number,
    ) {
        this.name = name;
        this.description = description;
        // this.building = building;
        this.members = members;
        this.groupID = groupID;
    }
}
