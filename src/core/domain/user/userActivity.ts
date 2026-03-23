
export interface IUserActivityRegistry{
    userID: number;
    activityType: string;
    distance: number;
    duration: string;
    caloriesBurned: number;
    avgCadence: number;
    avgSpeed: number;
    maxSpeed: number;
    elevationGain: number;
    steps: number;
    // registeredAt: Date;
}


export class UserActivity implements IUserActivityRegistry{
    public readonly activityID: number;
    public readonly userID: number;
    public readonly activityType: string;
    public readonly distance: number;
    public readonly duration: string;
    public readonly caloriesBurned: number;
    public readonly avgCadence: number;
    public readonly avgSpeed: number;
    public readonly maxSpeed: number;
    public readonly elevationGain: number;
    public readonly steps: number;
    public readonly registeredAt: Date;

    constructor(
        activityID: number,
        userID: number,
        activityType: string,
        disntace: number,
        duration: string,
        caloriesBurned: number,
        avgCadence: number,
        avgSpeed: number,
        maxSpeed: number,
        elevationGain: number,
        steps: number,
        registeredAt: Date
    ){
        this.activityID = activityID;
        this.userID = userID;
        this.activityType = activityType;
        this.distance = disntace;
        this.duration = duration;
        this.caloriesBurned = caloriesBurned;
        this.avgCadence = avgCadence;
        this.avgSpeed = avgSpeed;
        this.maxSpeed = maxSpeed;
        this.elevationGain = elevationGain;
        this.steps = steps;
        this.registeredAt = registeredAt;
    }


    // converts the date value to time value
    public static async convertToTime(duration: string): Promise<Date> {
        if (!duration || typeof duration !== "string") {
            throw new Error("Duration must be a non-empty string");
        }

        // Split into "HH:MM:SS" and fractional part safely
        const parts = duration.split(".");
        const hms = parts[0] || "";      // default to empty string
        const fraction = parts[1] || ""; // default to empty string

        const hmsParts = hms.split(":");
        if (hmsParts.length !== 3) {
            throw new Error(`Invalid duration format: ${duration}`);
        }

        const [hours, minutes, seconds] = hmsParts.map(Number);

        // if ([hours, minutes, seconds].some(isNaN)) {
        //     throw new Error(`Invalid duration numbers: ${duration}`);
        // }

        // Convert fractional part to milliseconds
        const milliseconds = Math.floor(Number("0." + fraction) * 1000);

        // Create Date object (time only)
        const time = new Date();
        time.setHours(Number(hours), minutes, seconds, milliseconds);

        return time;
    }
}

