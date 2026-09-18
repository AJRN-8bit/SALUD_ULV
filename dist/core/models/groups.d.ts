import type { IUser } from "./user.ts";
export interface IGroup {
    readonly groupID?: number | undefined;
    readonly name?: string;
    readonly description?: string;
    readonly members?: IUser[] | undefined;
}
export declare class Group implements IGroup {
    readonly groupID?: number | undefined;
    readonly name?: string;
    readonly description?: string;
    readonly members?: IUser[];
    constructor(name: string, description: string, members?: IUser[], groupID?: number);
}
//# sourceMappingURL=groups.d.ts.map