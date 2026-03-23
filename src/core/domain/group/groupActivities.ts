
export interface IGroupActivities{
    activityType: string;
    totalDistance: number;
    totalDuration: string;
    reportDate: Date;
}

export class GroupActivities implements IGroupActivities{
    activityID: number;
    groupID: number;
    activityType: string;
    totalDistance: number;
    totalDuration: string;
    reportDate: Date;

    constructor(
        activityID: number,
        groupID: number,
        activityType: string,
        totalDistance: number,
        totalDuration: string,
        reportDate: Date
    ) {
        this.activityID = activityID;
        this.groupID = groupID;
        this.activityType = activityType;
        this.totalDistance = totalDistance;
        this.totalDuration = totalDuration;
        this.reportDate = reportDate;
    }
}