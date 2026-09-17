// // Base abstract class for the user's physical activities.

// abstract class IPhysicalActivity {
//   activityID: string;
//   userUUID: string;
//   category: number;
//   // activityType?: string;
//   duration: number; // duration in seconds (TS/JS has no built-in Duration type)
//   caloriesBurned: number;
//   registeredAt: Date;

//   constructor(params: {
//     activityID: string;
//     userUUID: string;
//     category: number;
//     // activityType?: string;
//     duration: number;
//     caloriesBurned: number;
//     registeredAt: Date;
//   }) {
//     this.activityID = params.activityID;
//     this.userUUID = params.userUUID;
//     this.category = params.category;
//     // this.activityType = params.activityType;
//     this.duration = params.duration;
//     this.caloriesBurned = params.caloriesBurned;
//     this.registeredAt = params.registeredAt;
//   }
// }


// // Aerobics general class

// class Aerobics extends IPhysicalActivity {
//   distance?: number;
//   avgPace?: number;
//   elevationGain?: number;
//   avgCadence?: number;
//   heartRate?: number;

//   constructor(params: {
//     activityID?: string;
//     userUUID?: string;
//     category?: number;
//     // activityType?: string;
//     duration?: number;
//     caloriesBurned?: number;
//     registeredAt?: Date;

//     distance?: number;
//     avgPace?: number;
//     elevationGain?: number;
//     avgCadence?: number;
//     heartRate?: number;
//   }) {
//     super(params);
//     this.distance = params.distance;
//     this.avgPace = params.avgPace;
//     this.elevationGain = params.elevationGain;
//     this.avgCadence = params.avgCadence;
//     this.heartRate = params.heartRate;
//   }
// }


// class Walk extends Aerobics {
//   steps?: number;
//   avgSteps?: number;

//   constructor(params: {
//     activityID?: string;
//     userUUID?: string;
//     category?: number;
//     // activityType?: string;
//     duration?: number;
//     caloriesBurned?: number;
//     registeredAt?: Date;

//     distance?: number;
//     avgPace?: number;
//     elevationGain?: number;
//     avgCadence?: number;

//     steps?: number;
//     avgSteps?: number;
//   }) {
//     super(params);
//     this.steps = params.steps;
//     this.avgSteps = params.avgSteps;
//   }
// }

// export { IPhysicalActivity, Aerobics, Walk };