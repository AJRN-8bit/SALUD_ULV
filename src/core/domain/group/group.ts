
export interface IGroup{
    name: string,
}


export class Group implements IGroup{
    groupID: number;
    name: string;

    constructor(
        groupID: number,
        name: string
    ) {
        this.groupID = groupID;
        this.name = name;
    }
}